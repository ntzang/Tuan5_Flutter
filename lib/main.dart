import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Danh sach san pham',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(), // home: ProductListScreen(),
    );
  }
}
//dinh nghia HomeScreen
class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chu"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context)=>ProductListScreen()),);
          },
          child: Text('Go to ProductListScreen'),
        ),
      ),
    );

  }

}
class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>{
  late List<Product> product;
  @override
  void initState() {
    // TODO: implement initState
    //Khoi tao
    super.initState();
    product=[];
    fetchProduct();
  }
  //convert tu Map sang List
  List<Product> convertMapToProductList(Map<String,dynamic> data){
    List<Product> productList=[];
    data.forEach((key, value) {
      for(int i=0;i<value.length;i++)
      {
        Product product=Product(
            search_image: value[i]['search_image']?? '',
            styleid: value[i]['styleid']??0,
            brands_filter_facet: value[i]['brands_filter_facet']??'',
            price: value[i]['price']??0,
            product_additional_info: value[i]['product_additional_info']??'');
        productList.add(product);
      }
    });
    return productList;
  }
  //--ham doc du lieu tu server
  Future<void> fetchProduct() async {
    final response = await http.get(Uri.parse("http://192.168.1.14/asever/api.php"));
    if(response.statusCode==200){
      final Map<String,dynamic> data=json.decode(response.body);
      setState(() {
        product=convertMapToProductList(data);
      });
    }
    else {
      throw Exception("khong load duoc du lieu");
    }
  }
//---
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sach san pham'),
      ),
      body: product!=null ?
      ListView.builder(
        itemCount: product.length,
        itemBuilder: (context,index){
          return ListTile(
              title: Text(product[index].brands_filter_facet),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: ${product[index].price}'),
                  Text('product_additional_info: ${product[index].product_additional_info}'),
                ],
              ),
              leading: Image.network(
                product[index].search_image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
          );
        },
      )
          :Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
//--
class Product{
  String search_image;
  String styleid;
  String brands_filter_facet;
  String price;
  String product_additional_info;

  Product({ required this.search_image,
    required this.styleid,
    required this.brands_filter_facet,
    required this.price,
    required this.product_additional_info});
}
//-----
