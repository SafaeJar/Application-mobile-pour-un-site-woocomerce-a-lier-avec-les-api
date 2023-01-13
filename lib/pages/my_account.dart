import 'package:flutter/material.dart';
import 'package:woocommerce/pages/orders_page.dart';
import 'package:woocommerce/shared_service.dart';

import '../models/login_model.dart';

class MyAccount extends StatefulWidget {
 

  @override
  _MyAccountState createState() => _MyAccountState();
}
class OptionList{
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;
  OptionList(this.optionTitle,this.optionSubTitle,this.optionIcon,this.onTap
  );

}
class _MyAccountState extends State<MyAccount> {
  List<OptionList> options= new List<OptionList>();

  @override
  void initState(){
    super.initState();
    options.add( OptionList("Orders","Check my Orders",Icons.shopping_bag,(){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>OrdersPage()));

    }), );
     options.add( OptionList("Edit Profile","Update your profile",Icons.edit,(){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>OrdersPage()));

    }), );
     options.add( OptionList("Notifications","Check the lastetst notifications",Icons.notifications,(){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>OrdersPage()));

    }), );
     options.add( OptionList("Sign Out","Check my Orders",Icons.power_settings_new,(){
SharedService.logout().then((value)=>{setState((){})});

    }), );
  }
  
  
  
  
  @override
  Widget build(BuildContext context) {
    return _listView(context);
  }



Widget _buildRow(OptionList optionList, int index){
  return new Padding(padding: EdgeInsets.fromLTRB(0,5, 0,5),
  child: ListTile(
    leading: Container(
      padding: EdgeInsets.all(10),
      child: Icon(optionList.optionIcon,size: 30,),
    ),
    onTap: (){
      return optionList.onTap();
    },
  title: new Text(
    optionList.optionTitle,
    style: new TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    
  ),
  subtitle: Padding(
    padding: EdgeInsets.only(top: 5),
    child: Text(
      optionList.optionTitle,
      style: new TextStyle(
        color: Colors.redAccent,
        fontSize: 14,
      ),
    ),

  ),
  trailing: Icon(Icons.keyboard_arrow_right),
  ),

  );
}

Widget _listView(BuildContext context){
  
  return new FutureBuilder(

  future : SharedService.loginDetails(),
  builder: 
  (BuildContext context,
  AsyncSnapshot<LoginResponseModel> loginModel
  ){
   // if(loginModel.hasData){
      return ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(15, 15,0,0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome, ${loginModel.data.data.displayName}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                
                ),
              ],
            ),
          ),
          ListView.builder(
            itemCount: options.length,
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(8.0),
            shrinkWrap: true,
            itemBuilder: (context,index){
              return Card(
                elevation: 0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                child: _buildRow(options[index], index),
              );
            },

          )
        ],
      );

    }
   // return  Text("kjjlkhnk");

  //},
  );
}

}