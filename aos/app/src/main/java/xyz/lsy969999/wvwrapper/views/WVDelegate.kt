package xyz.lsy969999.wvwrapper.views

import android.webkit.JavascriptInterface
import android.webkit.WebView
import xyz.lsy969999.wvwrapper.models.WVViewModel

interface WVI {
    fun greeting(param1: String): String
}

class WVDelegate(private var context: WebView, private var model: WVViewModel): WVI {
    @JavascriptInterface
    override fun greeting(param1: String): String{
        return model.greeting(param1)
    }
}