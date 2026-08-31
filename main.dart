import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF101114),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SimpleCalculatorApp());
}

class SimpleCalculatorApp extends StatelessWidget {
  const SimpleCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101114),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFB9F5D0),
          secondary: Color(0xFFB9F5D0),
          surface: Color(0xFF181A1F),
        ),
        fontFamily: 'sans-serif',
        splashFactory: InkRipple.splashFactory,
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

enum _KeyKind { number, utility, operator, equals }

class _CalculatorKey {
  const _CalculatorKey(this.label, this.kind, {this.semanticLabel});

  final String label;
  final _KeyKind kind;
  final String? semanticLabel;
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late final CalculatorController _calculator;

  @override
  void initState() {
    super.initState();
    _calculator = CalculatorController()..addListener(_onCalculatorChanged);
  }

  @override
  void dispose() {
    _calculator
      ..removeListener(_onCalculatorChanged)
      ..dispose();
    super.dispose();
  }

  void _onCalculatorChanged() {
    setState(() {});
  }

  void _press(String key) {
    HapticFeedback.lightImpact();
    _calculator.press(key);
  }

  @override
  Widget build(BuildContext context) {
    final keys = <_CalculatorKey>[
      const _CalculatorKey('AC', _KeyKind.utility, semanticLabel: 'Clear'),
      const _CalculatorKey('±', _KeyKind.utility, semanticLabel: 'Toggle sign'),
      const _CalculatorKey('%', _KeyKind.utility, semanticLabel: 'Percentage'),
      const _CalculatorKey('÷', _KeyKind.operator, semanticLabel: 'Divide'),
      const _CalculatorKey('7', _KeyKind.number),
      const _CalculatorKey('8', _KeyKind.number),
      const _CalculatorKey('9', _KeyKind.number),
      const _CalculatorKey('×', _KeyKind.operator, semanticLabel: 'Multiply'),
      const _CalculatorKey('4', _KeyKind.number),
      const _CalculatorKey('5', _KeyKind.number),
      const _CalculatorKey('6', _KeyKind.number),
      const _CalculatorKey('−', _KeyKind.operator, semanticLabel: 'Subtract'),
      const _CalculatorKey('1', _KeyKind.number),
      const _CalculatorKey('2', _KeyKind.number),
      const _CalculatorKey('3', _KeyKind.number),
      const _CalculatorKey('+', _KeyKind.operator, semanticLabel: 'Add'),
      const _CalculatorKey('0', _KeyKind.number),
      const _CalculatorKey('00', _KeyKind.number),
      const _CalculatorKey(
        '.',
        _KeyKind.number,
        semanticLabel: 'Decimal point',
      ),
      const _CalculatorKey('=', _KeyKind.equals, semanticLabel: 'Equals'),
    ];

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 12, 18, 14),
        child: Column(
          children: [
            _Header(
              onClear: () => _press('AC'),
              onBackspace: () => _press('backspace'),
            ),
            const SizedBox(height: 18),
            Expanded(
              flex: 3,
              child: _Display(
                expression: _calculator.expression,
                value: _calculator.displayValue,
                hasError: _calculator.hasError,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              flex: 6,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: keys.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 11,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final key = keys[index];
                  return _CalculatorButton(
                    keyData: key,
                    onPressed: () => _press(key.label),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClear, required this.onBackspace});

  final VoidCallback onClear;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1E23),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF282C33)),
          ),
          child: const Icon(
            Icons.calculate_rounded,
            color: Color(0xFFB9F5D0),
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Simple Calculator',
                style: TextStyle(
                  color: Color(0xFFF4F6F7),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'QUICK • PRIVATE • OFFLINE',
                style: TextStyle(
                  color: Color(0xFF777E88),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onClear,
          tooltip: 'Clear',
          icon: const Icon(Icons.restart_alt_rounded),
          color: const Color(0xFF8B929D),
          iconSize: 22,
        ),
        IconButton(
          onPressed: onBackspace,
          tooltip: 'Backspace',
          icon: const Icon(Icons.backspace_outlined),
          color: const Color(0xFF8B929D),
          iconSize: 21,
        ),
      ],
    );
  }
}

class _Display extends StatelessWidget {
  const _Display({
    required this.expression,
    required this.value,
    required this.hasError,
  });

  final String expression;
  final String value;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final displayColor = hasError
        ? const Color(0xFFFF9D9D)
        : const Color(0xFFF4F6F7);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: const Color(0xFF17191E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF23262D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topRight,
                child: Text(
                  expression.isEmpty ? ' ' : expression,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF7E8792),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomRight,
              child: Text(
                value,
                maxLines: 1,
                style: TextStyle(
                  color: displayColor,
                  fontSize: hasError ? 30 : 54,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -1.8,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorButton extends StatelessWidget {
  const _CalculatorButton({required this.keyData, required this.onPressed});

  final _CalculatorKey keyData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isOperator = keyData.kind == _KeyKind.operator;
    final isEquals = keyData.kind == _KeyKind.equals;
    final isUtility = keyData.kind == _KeyKind.utility;
    final background = isEquals
        ? const Color(0xFFB9F5D0)
        : isOperator
        ? const Color(0xFF273A34)
        : isUtility
        ? const Color(0xFF2A2D33)
        : const Color(0xFF1D2025);
    final foreground = isEquals
        ? const Color(0xFF0E2118)
        : isOperator
        ? const Color(0xFFB9F5D0)
        : isUtility
        ? const Color(0xFFCDD2D8)
        : const Color(0xFFF4F6F7);

    return Semantics(
      button: true,
      label: keyData.semanticLabel ?? keyData.label,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(isEquals ? 24 : 22),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(isEquals ? 24 : 22),
          splashColor: Color.fromRGBO(
            foreground.red,
            foreground.green,
            foreground.blue,
            0.14,
          ),
          highlightColor: Color.fromRGBO(
            foreground.red,
            foreground.green,
            foreground.blue,
            0.08,
          ),
          child: Center(
            child: Text(
              keyData.label,
              style: TextStyle(
                color: foreground,
                fontSize: keyData.label == 'AC' ? 18 : 26,
                fontWeight: isEquals || isOperator
                    ? FontWeight.w700
                    : FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Stateful calculator engine kept independent from the Flutter widgets.
///
/// Percentages are evaluated using everyday calculator rules:
/// 100 + 10% becomes 100 + (100 * 10 / 100), while 10 × 50% becomes
/// 10 × (50 / 100).
class CalculatorController extends ChangeNotifier {
  String _current = '0';
  double? _left;
  String? _operator;
  bool _isEnteringSecond = false;
  bool _justEvaluated = false;
  bool _percentPending = false;
  String? _lastExpression;
  String? _error;

  String get displayValue => _error ?? _current;

  String get expression {
    if (_error != null) return 'Calculation error';
    if (_operator != null && _left != null) {
      final left = _formatNumber(_left!);
      final op = _operator!;
      return _percentPending
          ? '$left $op $_current%'
          : '$left $op${_isEnteringSecond ? ' ' : ''}';
    }
    return _justEvaluated ? _lastExpression ?? '' : '';
  }

  bool get hasError => _error != null;

  void press(String key) {
    if (_error != null && key != 'AC') {
      _clear();
    }

    switch (key) {
      case 'AC':
        _clear();
        break;
      case 'backspace':
        _backspace();
        break;
      case '.':
        _decimal();
        break;
      case '±':
        _toggleSign();
        break;
      case '%':
        _percentage();
        break;
      case '+':
      case '−':
      case '×':
      case '÷':
        _setOperator(key);
        break;
      case '=':
        _equals();
        break;
      default:
        if (_isDigitKey(key)) _digit(key);
        break;
    }
    notifyListeners();
  }

  bool _isDigitKey(String key) => RegExp(r'^\d+$').hasMatch(key);

  void _digit(String digit) {
    if (_justEvaluated && _operator == null) {
      _clear();
    }
    if (_percentPending) {
      _percentPending = false;
      _current = '0';
    }
    if (!_isEnteringSecond && _operator != null) {
      _current = '0';
      _isEnteringSecond = true;
    }
    if (_current == '0') {
      _current = digit == '00' ? '0' : digit;
    } else if (_current == '-0') {
      _current = digit == '00' ? '-0' : '-$digit';
    } else {
      _current += digit;
    }
    _justEvaluated = false;
  }

  void _decimal() {
    if (_justEvaluated && _operator == null) {
      _clear();
    }
    if (_percentPending) {
      _percentPending = false;
      _current = '0';
    }
    if (!_isEnteringSecond && _operator != null) {
      _current = '0';
      _isEnteringSecond = true;
    }
    if (!_current.contains('.')) {
      _current += '.';
    }
    _justEvaluated = false;
  }

  void _toggleSign() {
    if (_current == '0' || _current == '0.') return;
    _current = _current.startsWith('-') ? _current.substring(1) : '-$_current';
    _justEvaluated = false;
  }

  void _backspace() {
    if (_error != null) {
      _clear();
      return;
    }
    if (_justEvaluated) {
      _justEvaluated = false;
      _lastExpression = null;
    }
    if (_percentPending) _percentPending = false;
    if (_current.length <= 1 ||
        (_current.length == 2 && _current.startsWith('-'))) {
      _current = '0';
    } else {
      _current = _current.substring(0, _current.length - 1);
      if (_current == '-' || _current.isEmpty) _current = '0';
    }
  }

  void _percentage() {
    if (_operator == null || _left == null) {
      final value = _parseCurrent();
      if (value != null) {
        _current = _formatNumber(value / 100);
        _justEvaluated = true;
        _lastExpression = '${_formatNumber(value)}%';
      }
      return;
    }

    final operand = _parseCurrent();
    if (operand == null) return;
    if (_operator == '×' || _operator == '÷') {
      _current = _formatNumber(operand / 100);
      _percentPending = false;
    } else {
      _percentPending = true;
    }
  }

  void _setOperator(String nextOperator) {
    if (_operator != null && _isEnteringSecond) {
      _equals();
    } else if (_justEvaluated) {
      _left = _parseCurrent();
    } else if (_left == null) {
      _left = _parseCurrent();
    }
    if (_left == null) return;
    _operator = nextOperator;
    _isEnteringSecond = false;
    _percentPending = false;
    _justEvaluated = false;
    _lastExpression = null;
  }

  void _equals() {
    if (_operator == null || _left == null) return;

    final right = _parseCurrent();
    if (right == null) return;
    final calculatedOperand = _effectiveRightOperand(right);
    final result = _calculate(_left!, calculatedOperand, _operator!);
    if (result == null) {
      _error = "Can't divide by zero";
      return;
    }

    _lastExpression =
        '${_formatNumber(_left!)} $_operator ${_formatNumber(right)}';
    _current = _formatNumber(result);
    _left = null;
    _operator = null;
    _isEnteringSecond = false;
    _percentPending = false;
    _justEvaluated = true;
  }

  double _effectiveRightOperand(double right) {
    if (_percentPending && (_operator == '+' || _operator == '−')) {
      return (_left! * right) / 100;
    }
    return right;
  }

  double? _calculate(double left, double right, String operator) {
    switch (operator) {
      case '+':
        return left + right;
      case '−':
        return left - right;
      case '×':
        return left * right;
      case '÷':
        return right == 0 ? null : left / right;
    }
    return null;
  }

  double? _parseCurrent() => double.tryParse(_current);

  void _clear() {
    _current = '0';
    _left = null;
    _operator = null;
    _isEnteringSecond = false;
    _justEvaluated = false;
    _percentPending = false;
    _lastExpression = null;
    _error = null;
  }

  String _formatNumber(double value) {
    if (value.abs() < 0.000000000001) value = 0;
    var result = value.toStringAsFixed(12);
    result = result.replaceFirst(RegExp(r'\.?0+$'), '');
    if (result == '-0' || result.isEmpty) return '0';
    return result;
  }
}
