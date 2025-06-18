import 'package:flutter/material.dart';

// Add this import to your home_screen.dart file
// import 'routine_detail_screen.dart';

class RoutineDetailScreen extends StatefulWidget {
  final String routineType; // 'Morning' or 'Night'
  final String skinType;
  final List<String> skinConcerns;

  const RoutineDetailScreen({
    super.key,
    required this.routineType,
    required this.skinType,
    required this.skinConcerns,
  });

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  List<RoutineStep> routineSteps = [];
  bool wantCustomProducts = false;

  @override
  void initState() {
    super.initState();
    _initializeRoutineSteps();
  }

  void _initializeRoutineSteps() {
    List<String> stepNames = _getRoutineSteps(widget.routineType);
    routineSteps = stepNames.map((step) => RoutineStep(
      name: step,
      isCompleted: false,
      product: '',
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.routineType == 'Morning'
              ? 'Good morning, youssef!'
              : 'Good evening, youssef!',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Routine Header
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  '${widget.routineType} Routine',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  widget.routineType == 'Morning'
                      ? Icons.wb_sunny_outlined
                      : Icons.nightlight_outlined,
                  color: widget.routineType == 'Morning'
                      ? Colors.orange
                      : Colors.indigo,
                  size: 28,
                ),
              ],
            ),
          ),

          // Today's Routine Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Todays Routine',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Routine Steps
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: routineSteps.length,
              itemBuilder: (context, index) {
                return _buildRoutineStepCard(routineSteps[index], index);
              },
            ),
          ),

          // Bottom Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Custom Products Question
                Text(
                  'want a Routine from products you already have ?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Yes Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showProductInputDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineStepCard(RoutineStep step, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (step.product.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    step.product,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: step.isCompleted,
              onChanged: (value) {
                setState(() {
                  step.isCompleted = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF6B73FF),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _showProductInputDialog() {
    showDialog(
      context: context,
      builder: (context) => ProductInputDialog(
        routineSteps: routineSteps,
        onProductsUpdated: (updatedSteps) {
          setState(() {
            routineSteps = updatedSteps;
          });
        },
      ),
    );
  }

  List<String> _getRoutineSteps(String routineType) {
    if (routineType == 'Morning') {
      switch (widget.skinType) {
        case 'Oily':
          return ['Gentle cleanser', 'Niacinamide serum', 'Light moisturizer', 'SPF 30+'];
        case 'Dry':
          return ['Hydrating cleanser', 'Hyaluronic acid serum', 'Rich moisturizer', 'SPF 30+'];
        case 'Sensitive':
          return ['Gentle cleanser', 'Fragrance-free moisturizer', 'SPF 30+ (mineral)'];
        case 'Combination':
          return ['Balanced cleanser', 'Light serum', 'Gel moisturizer', 'SPF 30+'];
        default:
          return ['Gentle cleanser', 'Moisturizer', 'SPF 30+'];
      }
    } else {
      switch (widget.skinType) {
        case 'Oily':
          return ['Oil cleanser', 'Gentle cleanser', 'BHA treatment', 'Night moisturizer'];
        case 'Dry':
          return ['Oil cleanser', 'Hydrating cleanser', 'Rich serum', 'Night cream'];
        case 'Sensitive':
          return ['Gentle cleanser', 'Soothing serum', 'Rich moisturizer'];
        case 'Combination':
          return ['Oil cleanser', 'Balanced cleanser', 'Targeted treatments', 'Night moisturizer'];
        default:
          return ['Cleanser', 'Treatment', 'Night moisturizer'];
      }
    }
  }
}

class ProductInputDialog extends StatefulWidget {
  final List<RoutineStep> routineSteps;
  final Function(List<RoutineStep>) onProductsUpdated;

  const ProductInputDialog({
    super.key,
    required this.routineSteps,
    required this.onProductsUpdated,
  });

  @override
  State<ProductInputDialog> createState() => _ProductInputDialogState();
}

class _ProductInputDialogState extends State<ProductInputDialog> {
  final TextEditingController _productController = TextEditingController();
  late List<RoutineStep> _tempSteps;
  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _tempSteps = widget.routineSteps.map((step) => RoutineStep(
      name: step.name,
      isCompleted: step.isCompleted,
      product: step.product,
    )).toList();
    _productController.text = _tempSteps[_currentStepIndex].product;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Type for us your products!',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tempSteps[_currentStepIndex].name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _productController,
            decoration: InputDecoration(
              hintText: 'Cleanser, etc',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6B73FF)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_tempSteps.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _currentStepIndex
                      ? const Color(0xFF6B73FF)
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
      actions: [
        if (_currentStepIndex < _tempSteps.length - 1)
          TextButton(
            onPressed: _nextStep,
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          TextButton(
            onPressed: _finishSetup,
            child: const Text(
              'Finish',
              style: TextStyle(
                color: Color(0xFF6B73FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  void _nextStep() {
    // Save current product
    _tempSteps[_currentStepIndex].product = _productController.text.trim();

    if (_currentStepIndex < _tempSteps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _productController.text = _tempSteps[_currentStepIndex].product;
      });
    }
  }

  void _finishSetup() {
    // Save final product
    _tempSteps[_currentStepIndex].product = _productController.text.trim();

    // Update the parent widget
    widget.onProductsUpdated(_tempSteps);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _productController.dispose();
    super.dispose();
  }
}

class RoutineStep {
  final String name;
  bool isCompleted;
  String product;

  RoutineStep({
    required this.name,
    required this.isCompleted,
    required this.product,
  });
}