# WXLCacheImage 
这是一个异步加载图片的工程。
1、第一次从服务端请求到图片以后，将图片数据同时存储到本地和内存当中做缓冲数据	
2、下次获取数据时，首先从内存去拿（因为内存读取数据是最快的），如果没有，
3、再从本地去拿，如果没有，
4、再去请求服务器的数据，这样可以降低服务器的压力，减少服务器带宽
