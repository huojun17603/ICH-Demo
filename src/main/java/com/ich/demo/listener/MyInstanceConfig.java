package com.ich.demo.listener;

import com.netflix.appinfo.MyDataCenterInstanceConfig;

import java.net.InetAddress;
import java.net.UnknownHostException;

public class MyInstanceConfig extends MyDataCenterInstanceConfig {

    @Override
    public String getHostName(boolean refresh) {
        try {
            return InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            return super.getHostName(refresh);
        }
    }

}
