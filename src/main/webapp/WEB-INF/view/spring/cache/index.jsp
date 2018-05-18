<%@ page language="java" import="java.util.*,com.ich.core.listener.SystemConfig" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  	<head>
	    <base href="<%=basePath%>">
	    <title>网站后台管理首页面</title>
		<link rel="stylesheet" type="text/css" href="<%=basePath%>css/spring/avatar.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath%>css/spring/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath%>css/spring/content_toolbar.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath%>css/spring/main.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath%>css/spring/markdown_views.css">
 	</head>
  	<body>
		<div id="article_content" class="article_content csdn-tracking-statistics tracking-click" data-mod="popu_519" data-dsm="post" style="overflow: hidden;">
		<div class="markdown_views">
		<h1 id="1-spring-对缓存的介绍"><a name="t0"></a>1 Spring 对缓存的介绍</h1>

		<blockquote>
		<p>Since version 3.1, Spring Framework provides support for transparently adding caching into an existing Spring application. <br>
		Similar to the transaction support, the caching abstraction allows <br>
		consistent use of various caching solutions with minimal impact on the <br>
		code. <br>
		As from Spring 4.1, the cache abstraction has been significantly <br>
		improved with the support of JSR-107 annotations and more <br>
		customization options.</p>
		</blockquote>

		<p>意思就是说从3.1开始Spring提供透明的缓存机制，Spring的缓存侵入性小，从4.1开始支持JSR-107注解，还可以定制。</p>

		<p>让我们进入正题。</p>



		<h1 id="2-什么是缓存"><a name="t1"></a>2 什么是缓存</h1>

		<p><em>当缓存被使用的时候，执行java方法时会首先缓存中检查执行的方法是否被执行过，如果执行过，就返回缓存中的数据；如果没有，就去执行方法，并且把结果缓存起来，下一次执行方法的时候直接返回缓存中的数据。</em></p>

		<p>翻译自Spring官方文档，英文水平有限，请包涵。</p>



		<h2 id="前提条件"><a name="t2"></a>前提条件</h2>

		<blockquote>
		<p>对于相同的输入，不论执行多少次方法总会返回同样的输出结果。</p>
		</blockquote>

		<p>Spring的缓存服务是抽象的，这种抽象将开发人员从编写缓存逻辑中解放出来，Spring对抽象缓存提供了具体的实现，它是通过以下两个接口实现的的。</p>

		<pre class="prettyprint"><code class="has-numbering">org.springframework.cache.Cache
		org.springframework.cache.CacheManager
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li></ul></pre>

		<p>有以下几种实现</p>

		<pre class="prettyprint"><code class="has-numbering">JDK java.util.concurrent.ConcurrentMap based caches,
		EhCache,
		Guava caches，
		JSR-107 compliant caches
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li></ul></pre>

		<p>要使用抽象缓存，开发者需要注意以下两点：</p>

		<ul>
		<li>缓存定义 <br>
		定义需要缓存的方法和策略 <font color="red">主要使用注解</font></li>
		<li>缓存配置 <br>
		缓存存取的位置 <font color="red">主要配置Cache和CacheManager</font></li>
		</ul>



		<h1 id="3-定义缓存"><a name="t3"></a>3 定义缓存</h1>

		<p>Spring提供了一下的注解来定义抽象缓存</p>

		<pre class="prettyprint"><code class="has-numbering">@Cacheable triggers cache population
		@CacheEvict triggers cache eviction
		@CachePut updates the cache without interfering with the method execution
		@Caching regroups multiple cache operations to be applied on a method
		@CacheConfig shares some common cache-related settings at class-level
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li></ul></pre>



		<h2 id="cacheable"><a name="t4"></a>@Cacheable</h2>

		<p>使用@Cacheable来定义缓存</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-annotation">@Cacheable</span>(<span class="hljs-string">"books"</span>)
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">findBook</span>(ISBN isbn) {...}</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li></ul></pre>

		<p>findBook 方法会缓存在 books这个缓存中</p>



		<h3 id="key"><a name="t5"></a>key</h3>

		<p>因为缓存都是<font color="red">key-value</font>形式的，value就是返回值，而key可以有各种各样的，所以必须有一个key的生成策略，如果不指定key，Spring会帮我们生成。</p>

		<p>默认生成策略如下</p>

		<blockquote>
		<ul>
		<li>If no params are given, return SimpleKey.EMPTY.</li>
		<li>If only one param is given, return that instance. </li>
		<li>If more the one param is given, return a SimpleKey containing all parameters.</li>
		</ul>
		</blockquote>

		<p>如果方法没有参数，则使用SimpleKey.EMPTY作为key。 <br>
		如果只有一个参数的话则使用该参数作为key。 <br>
		如果参数多于一个的话则使用所有参数的hashCode作为key。</p>

		<p><img src="http://img.blog.csdn.net/20160310170329993" alt="这里写图片描述" title=""></p>

		<p>从源码来看如果没有参数会报错，最好还是在有参数的方法上缓存。</p>

		<p>下面介绍Spring中SpEL的key属性</p>

		<p>可以通过Spring的EL表达式来指定我们的key。这里的EL表达式可以使用方法参数及它们对应的属性。使用方法参数时我们可以直接使用“#参数名”或者“#p参数index”。</p>

		<p>请看示例</p>

		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-comment">// 将isbn作为key</span>
		<span class="hljs-annotation">@Cacheable</span>(cacheNames=<span class="hljs-string">"books"</span>, key=<span class="hljs-string">"#isbn"</span>)
		<span class="hljs-comment">//或者 @Cacheable(cacheNames="books", key="#p0")</span>
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">findBook</span>(ISBN isbn, <span class="hljs-keyword">boolean</span> checkWarehouse, <span class="hljs-keyword">boolean</span> includeUsed)</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li></ul></pre>

		<p>上面的程序代码中将isbn作为缓存books的key，返回值Book作为value。</p>

		<h3 id="有条件缓存"><a name="t6"></a>有条件缓存</h3>

		<p>并不一定每次都需要缓存，可以根据参数来确定是否缓存，Spring提供了condition参数，通过判断true或者false来决定是否执行方法</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-annotation">@Cacheable</span>(cacheNames=<span class="hljs-string">"book"</span>, condition=<span class="hljs-string">"#name.length() &lt; 32"</span>)
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">findBook</span>(String name)</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li></ul></pre>

		<p>如果name的长度小于32就执行方法，否则从缓存中取数据</p>

		<p>还有一个unless它是在方法之后来确实是否将结果放入缓存</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering">Cacheable(cacheNames=<span class="hljs-string">"book"</span>, condition=<span class="hljs-string">"#name.length() &lt; 32"</span>, unless=<span class="hljs-string">"#result.hardback"</span>)
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">findBook</span>(String name)</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li></ul></pre>



		<h2 id="cacheput"><a name="t7"></a>@CachePut</h2>

		<p>方法永远会被执行，并把结果放入缓存</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-annotation">@CachePut</span>(cacheNames=<span class="hljs-string">"book"</span>, key=<span class="hljs-string">"#isbn"</span>)
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">updateBook</span>(ISBN isbn, BookDescriptor descriptor)</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li></ul></pre>

		<p>通常用在更新的方法上</p>



		<h2 id="cacheevict"><a name="t8"></a>@CacheEvict</h2>

		<p>将缓存移除</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-annotation">@CacheEvict</span>(cacheNames=<span class="hljs-string">"books"</span>, allEntries=<span class="hljs-keyword">true</span>)
		<span class="hljs-keyword">public</span> <span class="hljs-keyword">void</span> <span class="hljs-title">loadBooks</span>(InputStream batch)</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li></ul></pre>

		<p>allEntries=true表明所有的books中的缓存将被移除</p>



		<h2 id="caching"><a name="t9"></a>@Caching</h2>

		<p>当一个类型有多个注解的时候使用</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-annotation">@Caching</span>(evict = { <span class="hljs-annotation">@CacheEvict</span>(<span class="hljs-string">"primary"</span>), <span class="hljs-annotation">@CacheEvict</span>(cacheNames=<span class="hljs-string">"secondary"</span>, key=<span class="hljs-string">"#p0"</span>) })
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">importBooks</span>(String deposit, Date date)</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li></ul></pre>

		<p>第一个@CacheEvict(“primary”)使用默认值清除名称为primary的缓存，第二个@CacheEvict(cacheNames=”secondary”, key=”#p0”)表示importBooks(String deposit, Date date)的第一个参数作为key清除掉名称为secondary的缓存</p>



		<h2 id="cacheconfig"><a name="t10"></a>@CacheConfig</h2>

		<p>每次写的时候都需要指定cacheNames，如果都使用同一个cacheNames，可以使用@CacheConfig，将其放在类上</p>



		<pre class="prettyprint"><code class="hljs java has-numbering"><span class="hljs-annotation">@CacheConfig</span>(<span class="hljs-string">"books"</span>)
		<span class="hljs-keyword">public</span> <span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">BookRepositoryImpl</span> <span class="hljs-keyword">implements</span> <span class="hljs-title">BookRepository</span> {</span>
		<span class="hljs-annotation">@Cacheable</span>
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">findBook</span>(ISBN isbn) {...}
		}</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li></ul></pre>



		<h1 id="4-配置缓存"><a name="t11"></a>4 配置缓存</h1>

		<p>通过上面的分析可以知道缓存使用的两个关键，一个是定义缓存，另一个是配置缓存，上面主要讲了如何定义缓存，下面讲一下如何配置</p>

		<p><strong>首先，开启注解</strong></p>

		<pre class="prettyprint"><code class="has-numbering">&lt;cache:annotation-driven /&gt;
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li></ul></pre>

		<p>我们知道Spring的缓存通过两个接口来实现</p>

		<pre class="prettyprint"><code class="has-numbering">org.springframework.cache.Cache
		org.springframework.cache.CacheManager
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li></ul></pre>

		<p>下面介绍一下如何配置CacheManager，和Cache</p>

		<p>在Spring看来一切都是Bean，所以我们需要将<font color="red">CacheManager</font>和<font color="red">Cache</font>分别用Bean配置起来就ok了。</p>

		<p>其中需要配置的主要为Cache，Cache是数据缓存的位置，可以有很多种。</p>

		<ol>
		<li>JDK ConcurrentMap-based Cach </li>
		<li>EhCache-based Cache </li>
		<li>Guava Cache</li>
		<li>GemFire-based Cache</li>
		<li>JSR-107 Cache </li>
		</ol>

		<p>CacheManager是cache管理器，spring提供了多种实现，配置很简单。</p>

		<p>下面介绍一下JDK ConcurrentMap-based Cach和EhCache-based Cache的配置</p>



		<h2 id="jdk-concurrentmap-based-cach"><a name="t12"></a>JDK ConcurrentMap-based Cach</h2>



		<pre class="prettyprint"><code class="language-xml hljs  has-numbering"><span class="hljs-comment">&lt;!-- simple cache manager --&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">bean</span> <span class="hljs-attribute">id</span>=<span class="hljs-value">"cacheManager"</span> <span class="hljs-attribute">class</span>=<span class="hljs-value">"org.springframework.cache.support.SimpleCacheManager"</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">property</span> <span class="hljs-attribute">name</span>=<span class="hljs-value">"caches"</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">set</span>&gt;</span>
		<span class="hljs-comment">&lt;!-- 默认的缓存 --&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">bean</span> <span class="hljs-attribute">class</span>=<span class="hljs-value">"org.springframework.cache.concurrent.ConcurrentMapCacheFactoryBean"</span> <span class="hljs-attribute">p:name</span>=<span class="hljs-value">"default"</span>/&gt;</span>
		<span class="hljs-comment">&lt;!-- 例子中一直使用的"books",也就是那个cacheNames="books" --&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">bean</span> <span class="hljs-attribute">class</span>=<span class="hljs-value">"org.springframework.cache.concurrent.ConcurrentMapCacheFactoryBean"</span> <span class="hljs-attribute">p:name</span>=<span class="hljs-value">"books"</span>/&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">set</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">property</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">bean</span>&gt;</span></code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li></ul></pre>

		<p>完整的xml <br>
		spring-cache.xml</p>



		<pre class="prettyprint"><code class="language-xml hljs  has-numbering"><span class="hljs-pi">&lt;?xml version="1.0" encoding="UTF-8"?&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">beans</span> <span class="hljs-attribute">xmlns</span>=<span class="hljs-value">"http://www.springframework.org/schema/beans"</span>
		<span class="hljs-attribute">xmlns:xsi</span>=<span class="hljs-value">"http://www.w3.org/2001/XMLSchema-instance"</span> <span class="hljs-attribute">xmlns:p</span>=<span class="hljs-value">"http://www.springframework.org/schema/p"</span>
		<span class="hljs-attribute">xmlns:context</span>=<span class="hljs-value">"http://www.springframework.org/schema/context"</span>
		<span class="hljs-attribute">xmlns:cache</span>=<span class="hljs-value">"http://www.springframework.org/schema/cache"</span>
		<span class="hljs-attribute">xsi:schemaLocation</span>=<span class="hljs-value">"
		http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans-4.2.xsd
		http://www.springframework.org/schema/context
		http://www.springframework.org/schema/context/spring-context-4.2.xsd
		http://www.springframework.org/schema/cache
		http://www.springframework.org/schema/cache/spring-cache-4.2.xsd"</span>&gt;</span>

		<span class="hljs-tag">&lt;<span class="hljs-title">context:component-scan</span> <span class="hljs-attribute">base-package</span>=<span class="hljs-value">"com.gwc.springlearn"</span>/&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">cache:annotation-driven</span>/&gt;</span>

		<span class="hljs-comment">&lt;!-- simple cache manager --&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">bean</span> <span class="hljs-attribute">id</span>=<span class="hljs-value">"cacheManager"</span> <span class="hljs-attribute">class</span>=<span class="hljs-value">"org.springframework.cache.support.SimpleCacheManager"</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">property</span> <span class="hljs-attribute">name</span>=<span class="hljs-value">"caches"</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">set</span>&gt;</span>
		<span class="hljs-comment">&lt;!-- 默认的缓存 --&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">bean</span> <span class="hljs-attribute">class</span>=<span class="hljs-value">"org.springframework.cache.concurrent.ConcurrentMapCacheFactoryBean"</span> <span class="hljs-attribute">p:name</span>=<span class="hljs-value">"default"</span>/&gt;</span>
		<span class="hljs-comment">&lt;!-- 例子中一直使用的"books",也就是那个cacheNames="books" --&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">bean</span> <span class="hljs-attribute">class</span>=<span class="hljs-value">"org.springframework.cache.concurrent.ConcurrentMapCacheFactoryBean"</span> <span class="hljs-attribute">p:name</span>=<span class="hljs-value">"books"</span>/&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">set</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">property</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">bean</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">beans</span>&gt;</span></code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li><li style="color: rgb(153, 153, 153);">12</li><li style="color: rgb(153, 153, 153);">13</li><li style="color: rgb(153, 153, 153);">14</li><li style="color: rgb(153, 153, 153);">15</li><li style="color: rgb(153, 153, 153);">16</li><li style="color: rgb(153, 153, 153);">17</li><li style="color: rgb(153, 153, 153);">18</li><li style="color: rgb(153, 153, 153);">19</li><li style="color: rgb(153, 153, 153);">20</li><li style="color: rgb(153, 153, 153);">21</li><li style="color: rgb(153, 153, 153);">22</li><li style="color: rgb(153, 153, 153);">23</li><li style="color: rgb(153, 153, 153);">24</li><li style="color: rgb(153, 153, 153);">25</li><li style="color: rgb(153, 153, 153);">26</li><li style="color: rgb(153, 153, 153);">27</li><li style="color: rgb(153, 153, 153);">28</li></ul></pre>



		<h1 id="测试"><a name="t13"></a>测试</h1>



		<h2 id="项目结构"><a name="t14"></a>项目结构</h2>

		<p><img src="http://img.blog.csdn.net/20160303201857225" alt="这里写图片描述" title=""></p>

		<p>maven依赖</p>

		<p>pom.xml</p>



		<pre class="prettyprint"><code class="language-xml hljs  has-numbering"><span class="hljs-pi">&lt;?xml version="1.0" encoding="UTF-8"?&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">project</span> <span class="hljs-attribute">xmlns</span>=<span class="hljs-value">"http://maven.apache.org/POM/4.0.0"</span>
		<span class="hljs-attribute">xmlns:xsi</span>=<span class="hljs-value">"http://www.w3.org/2001/XMLSchema-instance"</span>
		<span class="hljs-attribute">xsi:schemaLocation</span>=<span class="hljs-value">"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">modelVersion</span>&gt;</span>4.0.0<span class="hljs-tag">&lt;/<span class="hljs-title">modelVersion</span>&gt;</span>

		<span class="hljs-tag">&lt;<span class="hljs-title">groupId</span>&gt;</span>com.gwc.springlearn<span class="hljs-tag">&lt;/<span class="hljs-title">groupId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">artifactId</span>&gt;</span>SpringCache<span class="hljs-tag">&lt;/<span class="hljs-title">artifactId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">version</span>&gt;</span>1.0-SNAPSHOT<span class="hljs-tag">&lt;/<span class="hljs-title">version</span>&gt;</span>

		<span class="hljs-tag">&lt;<span class="hljs-title">properties</span>&gt;</span>
		<span class="hljs-comment">&lt;!-- Spring --&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">spring-framework.version</span>&gt;</span>4.2.2.RELEASE<span class="hljs-tag">&lt;/<span class="hljs-title">spring-framework.version</span>&gt;</span>

		<span class="hljs-tag">&lt;/<span class="hljs-title">properties</span>&gt;</span>

		<span class="hljs-tag">&lt;<span class="hljs-title">dependencies</span>&gt;</span>
		<span class="hljs-comment">&lt;!--spring --&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">groupId</span>&gt;</span>org.springframework<span class="hljs-tag">&lt;/<span class="hljs-title">groupId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">artifactId</span>&gt;</span>spring-aop<span class="hljs-tag">&lt;/<span class="hljs-title">artifactId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">version</span>&gt;</span>${spring-framework.version}<span class="hljs-tag">&lt;/<span class="hljs-title">version</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">groupId</span>&gt;</span>org.springframework<span class="hljs-tag">&lt;/<span class="hljs-title">groupId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">artifactId</span>&gt;</span>spring-beans<span class="hljs-tag">&lt;/<span class="hljs-title">artifactId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">version</span>&gt;</span>${spring-framework.version}<span class="hljs-tag">&lt;/<span class="hljs-title">version</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">groupId</span>&gt;</span>org.springframework<span class="hljs-tag">&lt;/<span class="hljs-title">groupId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">artifactId</span>&gt;</span>spring-context-support<span class="hljs-tag">&lt;/<span class="hljs-title">artifactId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">version</span>&gt;</span>${spring-framework.version}<span class="hljs-tag">&lt;/<span class="hljs-title">version</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">groupId</span>&gt;</span>org.springframework<span class="hljs-tag">&lt;/<span class="hljs-title">groupId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">artifactId</span>&gt;</span>spring-core<span class="hljs-tag">&lt;/<span class="hljs-title">artifactId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">version</span>&gt;</span>${spring-framework.version}<span class="hljs-tag">&lt;/<span class="hljs-title">version</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">groupId</span>&gt;</span>org.springframework<span class="hljs-tag">&lt;/<span class="hljs-title">groupId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">artifactId</span>&gt;</span>spring-expression<span class="hljs-tag">&lt;/<span class="hljs-title">artifactId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">version</span>&gt;</span>${spring-framework.version}<span class="hljs-tag">&lt;/<span class="hljs-title">version</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">groupId</span>&gt;</span>org.springframework<span class="hljs-tag">&lt;/<span class="hljs-title">groupId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">artifactId</span>&gt;</span>spring-test<span class="hljs-tag">&lt;/<span class="hljs-title">artifactId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">version</span>&gt;</span>${spring-framework.version}<span class="hljs-tag">&lt;/<span class="hljs-title">version</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-comment">&lt;!--spring --&gt;</span>

		<span class="hljs-comment">&lt;!--junit--&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">groupId</span>&gt;</span>junit<span class="hljs-tag">&lt;/<span class="hljs-title">groupId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">artifactId</span>&gt;</span>junit<span class="hljs-tag">&lt;/<span class="hljs-title">artifactId</span>&gt;</span>
		<span class="hljs-tag">&lt;<span class="hljs-title">version</span>&gt;</span>4.12<span class="hljs-tag">&lt;/<span class="hljs-title">version</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">dependency</span>&gt;</span>
		<span class="hljs-comment">&lt;!--junit--&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">dependencies</span>&gt;</span>
		<span class="hljs-tag">&lt;/<span class="hljs-title">project</span>&gt;</span></code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li><li style="color: rgb(153, 153, 153);">12</li><li style="color: rgb(153, 153, 153);">13</li><li style="color: rgb(153, 153, 153);">14</li><li style="color: rgb(153, 153, 153);">15</li><li style="color: rgb(153, 153, 153);">16</li><li style="color: rgb(153, 153, 153);">17</li><li style="color: rgb(153, 153, 153);">18</li><li style="color: rgb(153, 153, 153);">19</li><li style="color: rgb(153, 153, 153);">20</li><li style="color: rgb(153, 153, 153);">21</li><li style="color: rgb(153, 153, 153);">22</li><li style="color: rgb(153, 153, 153);">23</li><li style="color: rgb(153, 153, 153);">24</li><li style="color: rgb(153, 153, 153);">25</li><li style="color: rgb(153, 153, 153);">26</li><li style="color: rgb(153, 153, 153);">27</li><li style="color: rgb(153, 153, 153);">28</li><li style="color: rgb(153, 153, 153);">29</li><li style="color: rgb(153, 153, 153);">30</li><li style="color: rgb(153, 153, 153);">31</li><li style="color: rgb(153, 153, 153);">32</li><li style="color: rgb(153, 153, 153);">33</li><li style="color: rgb(153, 153, 153);">34</li><li style="color: rgb(153, 153, 153);">35</li><li style="color: rgb(153, 153, 153);">36</li><li style="color: rgb(153, 153, 153);">37</li><li style="color: rgb(153, 153, 153);">38</li><li style="color: rgb(153, 153, 153);">39</li><li style="color: rgb(153, 153, 153);">40</li><li style="color: rgb(153, 153, 153);">41</li><li style="color: rgb(153, 153, 153);">42</li><li style="color: rgb(153, 153, 153);">43</li><li style="color: rgb(153, 153, 153);">44</li><li style="color: rgb(153, 153, 153);">45</li><li style="color: rgb(153, 153, 153);">46</li><li style="color: rgb(153, 153, 153);">47</li><li style="color: rgb(153, 153, 153);">48</li><li style="color: rgb(153, 153, 153);">49</li><li style="color: rgb(153, 153, 153);">50</li><li style="color: rgb(153, 153, 153);">51</li><li style="color: rgb(153, 153, 153);">52</li><li style="color: rgb(153, 153, 153);">53</li><li style="color: rgb(153, 153, 153);">54</li><li style="color: rgb(153, 153, 153);">55</li><li style="color: rgb(153, 153, 153);">56</li><li style="color: rgb(153, 153, 153);">57</li><li style="color: rgb(153, 153, 153);">58</li><li style="color: rgb(153, 153, 153);">59</li></ul></pre>



		<h2 id="需要的对象"><a name="t15"></a>需要的对象</h2>

		<p>Book.java</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-keyword">package</span> com.gwc.springlearn;

		<span class="hljs-javadoc">/**
		* Created by GWCheng on 2016/3/3.
		*/</span>
		<span class="hljs-keyword">public</span> <span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">Book</span> {</span>
		<span class="hljs-keyword">private</span> String bookISBN;
		<span class="hljs-keyword">private</span> String bookName;

		<span class="hljs-keyword">public</span> <span class="hljs-title">Book</span>(String bookISBN, String bookName) {
		<span class="hljs-keyword">this</span>.bookISBN = bookISBN;
		<span class="hljs-keyword">this</span>.bookName = bookName;
		}

		<span class="hljs-keyword">public</span> String <span class="hljs-title">getBookISBN</span>() {
		<span class="hljs-keyword">return</span> bookISBN;
		}

		<span class="hljs-keyword">public</span> <span class="hljs-keyword">void</span> <span class="hljs-title">setBookISBN</span>(String bookISBN) {
		<span class="hljs-keyword">this</span>.bookISBN = bookISBN;
		}

		<span class="hljs-keyword">public</span> String <span class="hljs-title">getBookName</span>() {
		<span class="hljs-keyword">return</span> bookName;
		}

		<span class="hljs-keyword">public</span> <span class="hljs-keyword">void</span> <span class="hljs-title">setBookName</span>(String bookName) {
		<span class="hljs-keyword">this</span>.bookName = bookName;
		}

		}
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li><li style="color: rgb(153, 153, 153);">12</li><li style="color: rgb(153, 153, 153);">13</li><li style="color: rgb(153, 153, 153);">14</li><li style="color: rgb(153, 153, 153);">15</li><li style="color: rgb(153, 153, 153);">16</li><li style="color: rgb(153, 153, 153);">17</li><li style="color: rgb(153, 153, 153);">18</li><li style="color: rgb(153, 153, 153);">19</li><li style="color: rgb(153, 153, 153);">20</li><li style="color: rgb(153, 153, 153);">21</li><li style="color: rgb(153, 153, 153);">22</li><li style="color: rgb(153, 153, 153);">23</li><li style="color: rgb(153, 153, 153);">24</li><li style="color: rgb(153, 153, 153);">25</li><li style="color: rgb(153, 153, 153);">26</li><li style="color: rgb(153, 153, 153);">27</li><li style="color: rgb(153, 153, 153);">28</li><li style="color: rgb(153, 153, 153);">29</li><li style="color: rgb(153, 153, 153);">30</li><li style="color: rgb(153, 153, 153);">31</li><li style="color: rgb(153, 153, 153);">32</li></ul></pre>

		<p>BookNotFoundException.java</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-keyword">package</span> com.gwc.springlearn;

		<span class="hljs-javadoc">/**
		* Created by GWCheng on 2016/3/3.
		*/</span>
		<span class="hljs-keyword">public</span> <span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">BookNotFoundException</span> <span class="hljs-keyword">extends</span> <span class="hljs-title">Exception</span> {</span>

		<span class="hljs-keyword">public</span> <span class="hljs-title">BookNotFoundException</span>(String msg){
		<span class="hljs-keyword">super</span>(msg);
		}
		}
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li><li style="color: rgb(153, 153, 153);">12</li></ul></pre>

		<p>CacheService.java</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-keyword">package</span> com.gwc.springlearn;

		<span class="hljs-keyword">import</span> org.springframework.cache.annotation.CacheConfig;
		<span class="hljs-keyword">import</span> org.springframework.cache.annotation.Cacheable;
		<span class="hljs-keyword">import</span> org.springframework.stereotype.Component;

		<span class="hljs-javadoc">/**
		* Created by GWCheng on 2016/3/3.
		*/</span>
		<span class="hljs-annotation">@Component</span>
		<span class="hljs-comment">//这里定义了之后就不必在下面的每个方法上写 cacheNames="books" 了</span>
		<span class="hljs-annotation">@CacheConfig</span>(cacheNames = <span class="hljs-string">"books"</span>)
		<span class="hljs-keyword">public</span> <span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">CacheService</span> {</span>

		<span class="hljs-annotation">@Cacheable</span>(key=<span class="hljs-string">"#isbn"</span>)
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">findBook</span>(String isbn) <span class="hljs-keyword">throws</span> BookNotFoundException {
		System.out.println(<span class="hljs-string">"isbn="</span>+isbn+<span class="hljs-string">" 方法调用"</span>);
		Book book = <span class="hljs-keyword">null</span>;
		<span class="hljs-keyword">if</span> (isbn == <span class="hljs-string">"123"</span>) {
		book = <span class="hljs-keyword">new</span> Book(<span class="hljs-string">"123"</span>, <span class="hljs-string">"Thinking in Java"</span>);
		} <span class="hljs-keyword">else</span> <span class="hljs-keyword">if</span> (isbn == <span class="hljs-string">"456"</span>) {
		book = <span class="hljs-keyword">new</span> Book(<span class="hljs-string">"456"</span>, <span class="hljs-string">"Effective Java"</span>);
		} <span class="hljs-keyword">else</span> {
		<span class="hljs-keyword">throw</span> <span class="hljs-keyword">new</span> BookNotFoundException(<span class="hljs-string">"没有找到isbn对应的书"</span>);
		}
		<span class="hljs-keyword">return</span> book;

		}
		}
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li><li style="color: rgb(153, 153, 153);">12</li><li style="color: rgb(153, 153, 153);">13</li><li style="color: rgb(153, 153, 153);">14</li><li style="color: rgb(153, 153, 153);">15</li><li style="color: rgb(153, 153, 153);">16</li><li style="color: rgb(153, 153, 153);">17</li><li style="color: rgb(153, 153, 153);">18</li><li style="color: rgb(153, 153, 153);">19</li><li style="color: rgb(153, 153, 153);">20</li><li style="color: rgb(153, 153, 153);">21</li><li style="color: rgb(153, 153, 153);">22</li><li style="color: rgb(153, 153, 153);">23</li><li style="color: rgb(153, 153, 153);">24</li><li style="color: rgb(153, 153, 153);">25</li><li style="color: rgb(153, 153, 153);">26</li><li style="color: rgb(153, 153, 153);">27</li><li style="color: rgb(153, 153, 153);">28</li><li style="color: rgb(153, 153, 153);">29</li><li style="color: rgb(153, 153, 153);">30</li></ul></pre>



		<h2 id="测试用例"><a name="t16"></a>测试用例</h2>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-keyword">package</span> com.gwc.springlearn;

		<span class="hljs-keyword">import</span> org.junit.Test;
		<span class="hljs-keyword">import</span> org.junit.runner.RunWith;
		<span class="hljs-keyword">import</span> org.springframework.beans.factory.annotation.Autowired;
		<span class="hljs-keyword">import</span> org.springframework.test.context.ContextConfiguration;
		<span class="hljs-keyword">import</span> org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

		<span class="hljs-javadoc">/**
		* Created by GWCheng on 2016/3/3.
		*/</span>
		<span class="hljs-annotation">@RunWith</span>(SpringJUnit4ClassRunner.class)
		<span class="hljs-annotation">@ContextConfiguration</span>(locations = {<span class="hljs-string">"classpath:spring-cache.xml"</span>})
		<span class="hljs-keyword">public</span> <span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">TestCacheService</span> {</span>
		<span class="hljs-annotation">@Autowired</span>
		<span class="hljs-keyword">private</span> CacheService cacheService;

		<span class="hljs-annotation">@Test</span>
		<span class="hljs-keyword">public</span> <span class="hljs-keyword">void</span> <span class="hljs-title">testCacheable</span>() <span class="hljs-keyword">throws</span> BookNotFoundException {
		<span class="hljs-keyword">for</span> (<span class="hljs-keyword">int</span> i = <span class="hljs-number">0</span>; i &lt; <span class="hljs-number">10</span>; i++) {
		cacheService.findBook(<span class="hljs-string">"123"</span>);
		}
		}
		}
		</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li><li style="color: rgb(153, 153, 153);">12</li><li style="color: rgb(153, 153, 153);">13</li><li style="color: rgb(153, 153, 153);">14</li><li style="color: rgb(153, 153, 153);">15</li><li style="color: rgb(153, 153, 153);">16</li><li style="color: rgb(153, 153, 153);">17</li><li style="color: rgb(153, 153, 153);">18</li><li style="color: rgb(153, 153, 153);">19</li><li style="color: rgb(153, 153, 153);">20</li><li style="color: rgb(153, 153, 153);">21</li><li style="color: rgb(153, 153, 153);">22</li><li style="color: rgb(153, 153, 153);">23</li><li style="color: rgb(153, 153, 153);">24</li><li style="color: rgb(153, 153, 153);">25</li></ul></pre>

		<p>首先，将CacheService的 @Cacheable(key=”#isbn”)注释掉 <br>
		运行测试用例</p>

		<p><img src="http://img.blog.csdn.net/20160303202906495" alt="这里写图片描述" title=""></p>

		<p>进行了十次方法调用，说明并没有缓存（因为我们没有开启缓存）。这个主要是用来做对比</p>



		<h3 id="测试cacheable"><a name="t17"></a>测试@Cacheable</h3>

		<p>CacheService的 @Cacheable(key=”#isbn”)开启</p>

		<p><img src="http://img.blog.csdn.net/20160303202803463" alt="这里写图片描述" title=""></p>

		<p>只调用了一次，说明已经缓存了。</p>



		<h3 id="测试-condition"><a name="t18"></a>测试 condition</h3>

		<p><img src="http://img.blog.csdn.net/20160303203316278" alt="这里写图片描述" title=""></p>

		<p>尽管缓存开启了，可是condition不满足了，还是执行方法法</p>

		<p><img src="http://img.blog.csdn.net/20160303203440794" alt="这里写图片描述" title=""></p>

		<p>开启缓存，并且condition满足，进行了缓存</p>



		<h3 id="测试-unless"><a name="t19"></a>测试 unless</h3>

		<p>Effective Java 的长度为14 <br>
		Thinking in Java的长度为16</p>

		<p>加上unless条件，只有返回结果的bookName的长度大于15才缓存</p>

		<p><img src="http://img.blog.csdn.net/20160303204223610" alt="这里写图片描述" title=""></p>

		<p>isbn为123的返回Effective Java长度不够，所以没有缓存</p>

		<p><img src="http://img.blog.csdn.net/20160303204348952" alt="这里写图片描述" title=""></p>

		<p>isbn为456的返回Thinking in Java长度满足条件，所以进行了缓存</p>



		<h3 id="测试-cacheput"><a name="t20"></a>测试 @CachePut</h3>

		<p>在CacheService中添加如下方法</p>



		<pre class="prettyprint"><code class="hljs cs has-numbering">    @CachePut(key=<span class="hljs-string">"#isbn"</span>)
		<span class="hljs-keyword">public</span> Book <span class="hljs-title">updateBook</span>(String isbn,String bookName){
		System.<span class="hljs-keyword">out</span>.println(<span class="hljs-string">"isbn="</span> + isbn + <span class="hljs-string">" bookName="</span>+bookName+<span class="hljs-string">" 更新缓存的方法被调用"</span>);
		Book book = <span class="hljs-keyword">new</span> Book(isbn,bookName);
		<span class="hljs-keyword">return</span> book;
		}</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li></ul></pre>

		<p>@CachePut表明该方法会将缓存中key为isbn的Book对象更新</p>

		<p>修改测试用例</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering"><span class="hljs-annotation">@Test</span>
		<span class="hljs-keyword">public</span> <span class="hljs-keyword">void</span> <span class="hljs-title">testCacheable</span>() <span class="hljs-keyword">throws</span> BookNotFoundException {
		Book book = <span class="hljs-keyword">null</span>;
		<span class="hljs-keyword">for</span> (<span class="hljs-keyword">int</span> i = <span class="hljs-number">0</span>; i &lt; <span class="hljs-number">10</span>; i++) {
		book = cacheService.findBook(<span class="hljs-string">"456"</span>);
		}
		System.out.println(<span class="hljs-string">"bookName= "</span>+book.getBookName());
		cacheService.updateBook(<span class="hljs-string">"456"</span>, <span class="hljs-string">"Spring 3.x企业应用开发实战"</span>);

		book = cacheService.findBook(<span class="hljs-string">"456"</span>);
		System.out.println(<span class="hljs-string">"bookName= "</span>+book.getBookName());
		}</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li><li style="color: rgb(153, 153, 153);">12</li></ul></pre>

		<p>结果如下</p>

		<p><img src="http://img.blog.csdn.net/20160303210101441" alt="这里写图片描述" title=""></p>

		<p>@CachePut确实更改了缓存中key为isbn的Book对象</p>



		<h3 id="测试-cacheevict"><a name="t21"></a>测试 @CacheEvict</h3>

		<p>在CacheService中添加如下方法</p>



		<pre class="prettyprint"><code class="language-java hljs  has-numbering">   <span class="hljs-annotation">@CacheEvict</span>(allEntries=<span class="hljs-keyword">true</span>)
		<span class="hljs-keyword">public</span> <span class="hljs-keyword">void</span> <span class="hljs-title">loadBooks</span>(){
		System.out.println(<span class="hljs-string">"清除缓存的方法被调用"</span>);
		}</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li></ul></pre>

		<p>@CacheEvict将清除cacheNames = “books”中的所有数据</p>

		<p>更改测试用例</p>



		<pre class="prettyprint"><code class="hljs java has-numbering"> <span class="hljs-annotation">@Test</span>
		<span class="hljs-keyword">public</span> <span class="hljs-keyword">void</span> <span class="hljs-title">testCacheable</span>() <span class="hljs-keyword">throws</span> BookNotFoundException {
		Book book = <span class="hljs-keyword">null</span>;
		<span class="hljs-keyword">for</span> (<span class="hljs-keyword">int</span> i = <span class="hljs-number">0</span>; i &lt; <span class="hljs-number">10</span>; i++) {
		book = cacheService.findBook(<span class="hljs-string">"456"</span>);
		}
		<span class="hljs-comment">//清除缓存</span>
		cacheService.loadBooks();
		<span class="hljs-comment">//缓存中没有了</span>
		cacheService.findBook(<span class="hljs-string">"456"</span>);
		<span class="hljs-comment">//缓存中有</span>
		cacheService.findBook(<span class="hljs-string">"456"</span>);
		}</code><ul class="pre-numbering"><li style="color: rgb(153, 153, 153);">1</li><li style="color: rgb(153, 153, 153);">2</li><li style="color: rgb(153, 153, 153);">3</li><li style="color: rgb(153, 153, 153);">4</li><li style="color: rgb(153, 153, 153);">5</li><li style="color: rgb(153, 153, 153);">6</li><li style="color: rgb(153, 153, 153);">7</li><li style="color: rgb(153, 153, 153);">8</li><li style="color: rgb(153, 153, 153);">9</li><li style="color: rgb(153, 153, 153);">10</li><li style="color: rgb(153, 153, 153);">11</li><li style="color: rgb(153, 153, 153);">12</li><li style="color: rgb(153, 153, 153);">13</li></ul></pre>

		<p>结果如下</p>

		<p><img src="http://img.blog.csdn.net/20160303210804403" alt="这里写图片描述" title=""></p>

		<p>说明@CacheEvict确实清除了缓存中的数据</p>



		<h1 id="总结"><a name="t22"></a>总结</h1>

		<p>Spring的缓存确实很方便，通过几个简单的注解就可以完成基本的缓存操作，而且配置简单，本文讲解了Spring抽象缓存的用法，其中包括@Cacheable， @CachePut ，@CacheEvict，@CacheConfig等注解，还有condition和unless参数的用法。</p>

		<p>关于Spring与EhCache的整合参考</p>

		<p><a href="http://blog.csdn.net/frankcheng5143/article/details/50776542" target="_blank">整合之道–Spring整合EhCache</a></p>

		<h1 id="参考文献"><a name="t23"></a>参考文献</h1>

		<blockquote>
		<p><a href="http://docs.spring.io/spring/docs/current/spring-framework-reference/htmlsingle/" target="_blank">http://docs.spring.io/spring/docs/current/spring-framework-reference/htmlsingle/</a></p>
		</blockquote>

		<h1 ><a></a>应用场景及可行性分析</h1>

	<p>场景：一般运用于的场景应该是高访问低更改的数据</p>
	<p>注意：缓存机制本身也是存在系统资源消耗的、缓存时间、缓存大小、数据出入口的控制必须到位</p>
	<p>分布式：不支持</p>
	<p>处理机制：通过AOP切面拦截</p>
	<p>PS：Spring只提供了其缓存的规则和简单的缓存处理方案，并不能满足企业级的开发需求，可以开发更优秀的缓存控制或者第三方缓存</p>

		</div>
		</div>
	</body>
</html>
