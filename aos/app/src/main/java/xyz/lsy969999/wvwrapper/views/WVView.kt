package xyz.lsy969999.wvwrapper.views

import android.app.Dialog
import android.os.Build
import android.os.Message
import android.util.Log
import android.view.KeyEvent
import android.view.View
import android.webkit.JsResult
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.annotation.RequiresApi
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.viewinterop.AndroidView
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.viewmodel.compose.viewModel
import xyz.lsy969999.wvwrapper.models.WVViewModel

@Composable
fun WebViewScreen(
//    webViewClient: WebviewClient,
    wvViewModel: WVViewModel = viewModel(),
    modifier: Modifier = Modifier
) {
    AndroidView(
        factory = { context ->
            WebView(context).apply {
                settings.javaScriptEnabled = true
                webViewClient = CustomWebViewClient()

                settings.javaScriptCanOpenWindowsAutomatically = true
                settings.setSupportMultipleWindows(true)
                settings.loadWithOverviewMode = true
                settings.useWideViewPort = true
                settings.setSupportZoom(true)

                this.addJavascriptInterface(WVDelegate(this, wvViewModel), "Android")

                webChromeClient = CustomWebChromeClient()
            }
        },
        update = { webView ->
            webView.loadUrl("https://google.com")
        },
    )
//    ComposableLifecycle { _, event ->
//        when (event) {
//            Lifecycle.Event.ON_CREATE -> {
//                Log.d("TAG", "onCreate")
//            }
//            Lifecycle.Event.ON_START -> {
//                Log.d("TAG", "On Start")
//            }
//            Lifecycle.Event.ON_RESUME -> {
//                Log.d("TAG", "On Resume")
//            }
//            Lifecycle.Event.ON_PAUSE -> {
//                Log.d("TAG", "On Pause")
//            }
//            Lifecycle.Event.ON_STOP -> {
//                Log.d("TAG", "On Stop")
//            }
//            Lifecycle.Event.ON_DESTROY -> {
//                Log.d("TAG", "On Destroy")
//            }
//            else -> {}
//        }
//    }
}

class CustomWebViewClient: WebViewClient() {
    override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
        val url = request?.url?.encodedQuery ?: "url"
        Log.d("TAG", "shouldOverrideUrlLoading: $url")
        return super.shouldOverrideUrlLoading(view, request)
    }
}

open class CustomWebChromeClient: WebChromeClient() {
    override fun onCreateWindow(
        view: WebView?,
        isDialog: Boolean,
        isUserGesture: Boolean,
        resultMsg: Message?
    ): Boolean {
        val context = view?.context ?: return false
        WebView(context).apply {
            settings.javaScriptEnabled = true
            settings.javaScriptCanOpenWindowsAutomatically = true
            settings.setSupportMultipleWindows(true)
            settings.setSupportZoom(true)

            val dialog = Dialog(context)
            dialog.setContentView(this)
            dialog.show()

            dialog.setOnKeyListener{ _, keyCode, _ ->
                if (keyCode == KeyEvent.KEYCODE_BACK) {
                    if(this.canGoBack()) {
                        this.goBack()
                    } else {
                        dialog.dismiss()
                    }
                    true
                } else {
                    false
                }
            }
            this.webViewClient = CustomWebViewClient()
            this.webChromeClient = object: CustomWebChromeClient() {
                override fun onCloseWindow(window: WebView?) {
                    window?.visibility = View.GONE
                    window?.destroy()
                    super.onCloseWindow(window)
                }
            }

            val transport = resultMsg?.obj as? WebView.WebViewTransport
            transport?.webView = this
            resultMsg?.sendToTarget()
        }
        return true
    }
}

@Composable
fun ComposableLifecycle(
    lifecycleOwner: LifecycleOwner = LocalLifecycleOwner.current,
    onEvent: (LifecycleOwner, Lifecycle.Event) -> Unit
) {

    DisposableEffect(lifecycleOwner) {
        val observer = LifecycleEventObserver { source, event ->
            onEvent(source, event)
        }
        lifecycleOwner.lifecycle.addObserver(observer)

        onDispose {
            lifecycleOwner.lifecycle.removeObserver(observer)
        }
    }
}
