package com.reactnativenavigation.parse.params;

import android.support.annotation.NonNull;

public class Text extends Param<String> {
    public Text(String value) {
        super(value);
    }

    @NonNull
    @Override
    public String toString() {
        return hasValue() ? value : "No Value";
    }
}
