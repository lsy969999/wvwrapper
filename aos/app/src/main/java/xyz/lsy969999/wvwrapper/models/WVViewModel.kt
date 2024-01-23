package xyz.lsy969999.wvwrapper.models

import androidx.lifecycle.ViewModel
import xyz.lsy969999.wvwrapper.views.WVI

class WVViewModel: ViewModel(), WVI {
    override fun greeting(param1: String): String {
        return "greeting + ${param1} z"
    }
}