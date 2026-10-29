import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const UnitConverterPage(),
    );
  }
}

class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  final TextEditingController inputController =
      TextEditingController(text: '1');

  final Map<String, List<String>> units = {
    'Length': ['Meter', 'Kilometer', 'Centimeter', 'Mile', 'Foot'],
    'Weight': ['Kilogram', 'Gram', 'Pound', 'Ounce'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Volume': ['Liter', 'Milliliter', 'Gallon'],
  };

  String category = 'Length';
  String fromUnit = 'Meter';
  String toUnit = 'Kilometer';
  String result = '0.001';
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    inputController.addListener(convert);
  }

  @override
  void dispose() {
    inputController.removeListener(convert);
    inputController.dispose();
    super.dispose();
  }

  double toBase(double value, String unit) {
    switch (category) {
      case 'Length':
        switch (unit) {
          case 'Kilometer':
            return value * 1000;
          case 'Centimeter':
            return value / 100;
          case 'Mile':
            return value * 1609.344;
          case 'Foot':
            return value * 0.3048;
          default:
            return value;
        }
      case 'Weight':
        switch (unit) {
          case 'Gram':
            return value / 1000;
          case 'Pound':
            return value * 0.45359237;
          case 'Ounce':
            return value * 0.028349523125;
          default:
            return value;
        }
      case 'Temperature':
        switch (unit) {
          case 'Fahrenheit':
            return (value - 32) * 5 / 9;
          case 'Kelvin':
            return value - 273.15;
          default:
            return value;
        }
      case 'Volume':
        switch (unit) {
          case 'Milliliter':
            return value / 1000;
          case 'Gallon':
            return value * 3.785411784;
          default:
            return value;
        }
      default:
        return value;
    }
  }

  double fromBase(double value, String unit) {
    switch (category) {
      case 'Length':
        switch (unit) {
          case 'Kilometer':
            return value / 1000;
          case 'Centimeter':
            return value * 100;
          case 'Mile':
            return value / 1609.344;
          case 'Foot':
            return value / 0.3048;
          default:
            return value;
        }
      case 'Weight':
        switch (unit) {
          case 'Gram':
            return value * 1000;
          case 'Pound':
            return value / 0.45359237;
          case 'Ounce':
            return value / 0.028349523125;
          default:
            return value;
        }
      case 'Temperature':
        switch (unit) {
          case 'Fahrenheit':
            return value * 9 / 5 + 32;
          case 'Kelvin':
            return value + 273.15;
          default:
            return value;
        }
      case 'Volume':
        switch (unit) {
          case 'Milliliter':
            return value * 1000;
          case 'Gallon':
            return value / 3.785411784;
          default:
            return value;
        }
      default:
        return value;
    }
  }

  void convert() {
    final value = double.tryParse(inputController.text.trim());

    if (value == null || !value.isFinite) {
      setState(() {
        result = '—';
        errorMessage = 'Enter a valid number.';
      });
      return;
    }

    final baseValue = toBase(value, fromUnit);

    if (category == 'Temperature' && baseValue < -273.15) {
      setState(() {
        result = '—';
        errorMessage = 'Temperature is below absolute zero.';
      });
      return;
    }

    final convertedValue = fromBase(baseValue, toUnit);

    setState(() {
      result = convertedValue.toStringAsPrecision(8);
      errorMessage = '';
    });
  }

  void changeCategory(String value) {
    setState(() {
      category = value;
      fromUnit = units[value]![0];
      toUnit = units[value]![1];
      errorMessage = '';
    });
    convert();
  }

  void swapUnits() {
    setState(() {
      final previousUnit = fromUnit;
      fromUnit = toUnit;
      toUnit = previousUnit;
    });
    convert();
  }

  void resetConverter() {
    inputController.removeListener(convert);
    inputController.text = '1';
    inputController.addListener(convert);

    setState(() {
      fromUnit = units[category]![0];
      toUnit = units[category]![1];
      errorMessage = '';
    });

    convert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Unit Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Convert anything.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Conversion category'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      isExpanded: true,
                      items: units.keys.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          changeCategory(value);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Enter value'),
                    const SizedBox(height: 8),
                    TextField(
                      key: const Key('converter_input'),
                      controller: inputController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter a number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('From unit'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      key: const Key('from_unit'),
                      initialValue: fromUnit,
                      isExpanded: true,
                      items: units[category]!.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            fromUnit = value;
                          });
                          convert();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: IconButton.filledTonal(
                        key: const Key('swap_units'),
                        onPressed: swapUnits,
                        icon: const Icon(Icons.swap_vert),
                        tooltip: 'Swap units',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('To unit'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      key: const Key('to_unit'),
                      initialValue: toUnit,
                      isExpanded: true,
                      items: units[category]!.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            toUnit = value;
                          });
                          convert();
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'CONVERTED RESULT',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          SelectableText(
                            result,
                            key: const Key('conversion_result'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(toUnit),
                          if (errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      key: const Key('reset_converter'),
                      onPressed: resetConverter,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Converter'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}