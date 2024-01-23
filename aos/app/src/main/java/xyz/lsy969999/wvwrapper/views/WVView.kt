package xyz.lsy969999.wvwrapper.views

import android.util.Log
import android.webkit.JsResult
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.viewinterop.AndroidView
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

                settings.loadWithOverviewMode = true
                settings.useWideViewPort = true
                settings.setSupportZoom(true)

                this.addJavascriptInterface(WVDelegate(this, wvViewModel), "Android")

                webChromeClient = WebChromeClient()//customWebChromeClient()
            }
        },
        update = { webView ->
            webView.loadUrl("https://google.com")
        }
    )
}

class CustomWebViewClient: WebViewClient() {
    override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
        val url = request?.url?.encodedQuery ?: "url"
        Log.d("TAG", "shouldOverrideUrlLoading: $url")
        return super.shouldOverrideUrlLoading(view, request)
    }
}

private fun customWebChromeClient(): WebChromeClient {
    val webChromeClient = object : WebChromeClient() {
        override fun onJsAlert(
            view: WebView?,
            url: String?,
            message: String?,
            result: JsResult?
        ): Boolean {
            //TODO
            Log.d("TAG", "onJsAlert: ")
            return super.onJsAlert(view, url, message, result)
        }

    }
    return webChromeClient
}