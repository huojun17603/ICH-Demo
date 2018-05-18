package com.ich.demo.listener;

import com.netflix.appinfo.MyDataCenterInstanceConfig;
import com.netflix.config.ConfigurationManager;
import com.netflix.client.ClientFactory;
import com.netflix.discovery.DefaultEurekaClientConfig;
import com.netflix.discovery.DiscoveryManager;
import com.netflix.loadbalancer.DynamicServerListLoadBalancer;
import com.netflix.loadbalancer.RoundRobinRule;
import com.netflix.loadbalancer.Server;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.io.IOException;
import java.util.Collections;
import java.util.stream.Collectors;

public class ServiceAddressSelector {
    /**
     * 默认的ribbon配置文件名, 该文件需要放在classpath目录下
     */
    public static final String RIBBON_CONFIG_FILE_NAME = "ribbon.properties";
    private static final Logger log = LoggerFactory.getLogger(ServiceAddressSelector.class);
    private static RoundRobinRule chooseRule = new RoundRobinRule();
    static {
        log.info("开始初始化ribbon");
        try {
            // 加载ribbon配置文件
            ConfigurationManager.loadPropertiesFromResources(RIBBON_CONFIG_FILE_NAME);
        } catch (IOException e) {
            e.printStackTrace();
            log.error("ribbon初始化失败");
            throw new IllegalStateException("ribbon初始化失败");
        }
        // 初始化Eureka Client
        DiscoveryManager.getInstance().initComponent(new MyDataCenterInstanceConfig(), new DefaultEurekaClientConfig());
        log.info("ribbon初始化完成");
    }

    /**
     * 根据轮询策略选择一个地址
     *
     * @param clientName
     *            ribbon.properties配置文件中配置项的前缀名, 如myclient
     * @return null表示该服务当前没有可用地址
     */
    public static AlanServiceAddress selectOne(String clientName) {
        // ClientFactory.getNamedLoadBalancer会缓存结果, 所以不用担心它每次都会向eureka发起查询
        DynamicServerListLoadBalancer lb = (DynamicServerListLoadBalancer) ClientFactory
                .getNamedLoadBalancer(clientName);
        Server selected = chooseRule.choose(lb, null);
        if (null == selected) {
            log.warn("服务{}没有可用地址", clientName);
            return null;
        }
        log.debug("服务{}选择结果:{}", clientName, selected);
        return new AlanServiceAddress(selected.getPort(), selected.getHost());
    }

    /**
     * 选出该服务所有可用地址
     *
     * @param clientName
     * @return
     */
    public static List<AlanServiceAddress> selectAvailableServers(String clientName) {
        DynamicServerListLoadBalancer lb = (DynamicServerListLoadBalancer) ClientFactory
                .getNamedLoadBalancer(clientName);
        List<Server> serverList = lb.getServerList(true);
        if (serverList.isEmpty()) {
            log.warn("服务{}没有可用地址", clientName);
            return Collections.emptyList();
        }
        log.debug("服务{}所有选择结果:{}", clientName, serverList);
        return serverList.stream().map(server -> new AlanServiceAddress(server.getPort(), server.getHost()))
                .collect(Collectors.toList());
    }

    public static void main(String[] args) {
        new Thread(new Runnable(){
            @Override
            public void run() {
                ServiceAddressSelector.selectAvailableServers("myclient");
            }
        }).start();
    }
}
