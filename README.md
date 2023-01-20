# giphy_picker

A Flutter package that allows you to pick animated GIF images from [Giphy](https://giphy.com).

![Gif](https://github.com/firstfloorsoftware/giphy_picker/blob/master/example/screenshots/giphy_picker_demo.gif)

## Getting Started

First, you need to register an app at the [Giphy Developers Portal](https://developers.giphy.com/) in order to retrieve an API key.

Pick a GIF:

```dart
import 'package:giphy_picker/giphy_picker.dart';

final gif = await GiphyPicker.pickGif(
                  context: context, 
                  apiKey: '[YOUR GIPHY APIKEY]');
```

Display a GIF using the ```GiphyImage``` widget. The following snippet demonstrates how to render a GIF in its original format:
```dart
Widget build(BuildContext context) {
  return GiphyImage.original(gif: gif);
}
```

Alternatively, load and display the GIF image using the ```Image``` widget:
```dart
Widget build(BuildContext context) {
  return Image.network(
      gif.images.original.url, 
      headers: {'accept': 'image/*'}))
}
```
