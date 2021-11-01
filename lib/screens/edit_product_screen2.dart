import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/product.dart';
import '../models/providers/products_provider.dart';

class EditProductScreen2 extends StatefulWidget {
  static const routeName = '/edit-product2';

  @override
  _EditProductScreen2State createState() => _EditProductScreen2State();
}

class _EditProductScreen2State extends State<EditProductScreen2> {
  final _priceFocusNode = FocusNode();
  final _decriptionFocusNode = FocusNode();
  final _imageUrlcontroller = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: '', title: '', price: 0, description: '', imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _decriptionFocusNode.dispose();
    _imageUrlcontroller.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlcontroller.text.startsWith('http') &&
              !_imageUrlcontroller.text.startsWith('https')) ||
          (!_imageUrlcontroller.text.endsWith('.png') &&
              !_imageUrlcontroller.text.endsWith('.jpg') &&
              !_imageUrlcontroller.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  // void _saveForm() {
  //   final isValid = _form.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   _form.currentState!.save();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if (_editedProduct.id != '') {
  //     Provider.of<Products>(context, listen: false)
  //         .updateProduct(_editedProduct.id, _editedProduct);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     Navigator.of(context).pop();
  //   } else {
  //     Provider.of<Products>(context, listen: false)
  //         .addProduct(_editedProduct)
  //         .catchError(
  //       (error) {
  //          return showDialog(
  //           context: context,
  //           builder: (BuildContext ctx) {
  //             return AlertDialog(
  //               title: Text('An error occured'),
  //               content: Text('SOMETHING WENT WRONG'),
  //               actions: <Widget>[
  //                 FlatButton(
  //                   child: Text('Okay'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       },
  //     ).then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       Navigator.of(context).pop();
  //     });
  //   }

  //   // _form.currentState!.save();
  //   // print(_editedProduct.title);
  //   // print(_editedProduct.price);
  //   // print(_editedProduct.description);
  //   // print(_editedProduct.imageUrl);
  // }
  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
     await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await  showDialog(
            context: context,
            builder: ( ctx) {
              return AlertDialog(
                title: Text('An error occured'),
                content: Text('SOMETHING WENT WRONG'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            });
      } 
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value.toString(),
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorites: _editedProduct.isFavorites,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_decriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(value!),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorites: _editedProduct.isFavorites,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter a number greater than zero";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _decriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value.toString(),
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorites: _editedProduct.isFavorites,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a description';
                        }
                        if (value.length < 10) {
                          return "Should be atleast 10 characters long";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlcontroller.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlcontroller.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlcontroller,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value.toString(),
                                id: _editedProduct.id,
                                isFavorites: _editedProduct.isFavorites,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
