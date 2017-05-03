# webapp-template

> FE team webapp-template

## Build Setup

``` bash
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build
```

For detailed explanation on how things work, checkout the [guide](http://vuejs-templates.github.io/webpack/) and [docs for vue-loader](http://vuejs.github.io/vue-loader).

### vue-cli version
2.7.0 [url](https://github.com/vuejs/vue-cli/tree/v2.7.0)

### vue version
2.1.0 [url](https://vuejs.org/)

### vue-router version
2.1.1 [url](http://router.vuejs.org/)

### axios version (promise http)
0.15.3 [url](https://github.com/mzabriskie/axios/tree/v0.15.3)

### 修改基础配置
1. 文件夹 `router` -> `index.js` 修改路由
2. 文件夹 `axios` -> `index.js` 修改通用错误处理，和服务端约束好错误码； `config.js` 修改 `axios` 初始配置
3. 文件夹 `config` -> `index.js` 修改代理配置 `proxyTable` 配置项下 `api` 修改为公用接口的 `***` , `target` 下是服务器的地址

### 参考
[金刚狼](http://news.163.com/special/fdh5_wolverine/)
上面下载生成js文件 -> `example/test.js`

[媒体相关事件](https://developer.mozilla.org/zh-CN/docs/Web/Guide/Events/Media_events)
[HTML5 Video Events and API](https://www.w3.org/2010/05/video/mediaevents.html)
[video标签在不同平台上的事件表现差异分析](http://imweb.io/topic/560a6015c2317a8c3e086207)
