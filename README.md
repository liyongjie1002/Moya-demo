# Moya-demo
项目中使用响应式编程，提升效率

此demo采用Moya+RxSwift+HandyJSON，作为项目中网络请求——>数据解析——>数据展示。代替传统方式。

Moya/RxSwift ，是RxSwift对Moya的扩展，提供了request方法，接着解析json数据，赋值数据源，绑定UI控件。

RxDataSources，分区，在这里一个分区，不管是多个分区，还是一个分区，都需要返回一个 section 的数组。