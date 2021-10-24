# Firstvoucher Mobile Client

A Flutter application to manage your vouchers for the voucher system [Firstvoucher](https://www.firstvoucher.com/).

##  Get Started

With this mobile client you are able to
- view all your vouchers
- search for specific vouchers by code-string or QR-Code
- create redeems for vouchers
- create new vouchers

<img src="/docs/Screen%20Shot%20Search.png" width="50%">

<img src="/docs/Screen%20Shot%20Create.png" width="50%">


## How to use

**Step 1:**

Download or clone this repo by using the link below:

```

https://github.com/zubairehman/flutter-boilerplate-project.git

```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```

flutter pub get

```

**Step 3:**

Open the *.env* file and set your values for the variables.

```

BASE_URL=# YOUR URL  
APP_NAME=# YOUR APP NAME  
AUTH_TOKEN=# YOUR AUTH TOKEN

```

| VARIABLE | DESCRIPTION |
|--|--|
| BASE_URL | Your url to the voucher shop. *E.g. https://www.example.firstvoucher.de* |
| APP_NAME | Your shop name. *E.g. Example shop vouchers* |
| AUTH_TOKEN | Create an auth token in the admin dashboard for your user. (*Settings > Account > User > Create or edit > Tab "Api Token" > New*) |

**Step 4:**

Run the app on your iOS or Android device.

```

flutter run

```

More information to run a flutter application you find here: https://flutter.dev/docs

## Set custom theme

**Step 1:**

Create a material theme with this tool: http://mcg.mbitson.com/ and copy the flutter code.

**Step 2:**

Open the file *lib/core/theme.dart* and replace the theme with your generated code.

```

const MaterialColor palette =  
    MaterialColor(palettePrimaryValue, <int, Color>{  
  50: Color(0xFFE5E6F3),  
  100: Color(0xFFBFC1E1),  
  200: Color(0xFF9497CD),  
  300: Color(0xFF696DB8),  
  400: Color(0xFF494EA9),  
  500: Color(palettePrimaryValue),  
  600: Color(0xFF242A92),  
  700: Color(0xFF1F2388),  
  800: Color(0xFF191D7E),  
  900: Color(0xFF0F126C),  
});  
  
const int palettePrimaryValue = 0xFF292F9A;  
  
const MaterialColor paletteAccent =  
    MaterialColor(paletteAccentValue, <int, Color>{  
  100: Color(0xFFA1A3FF),  
  200: Color(paletteAccentValue),  
  400: Color(0xFF3B3FFF),  
  700: Color(0xFF2126FF),  
});  
  
const int paletteAccentValue = 0xFF6E71FF;

```

##  Conclusion

I will be happy to answer any questions that you may have, and if you want to lend a hand with the app then please feel free to submit an issue and/or pull request 🙂