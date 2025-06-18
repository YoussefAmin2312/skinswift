import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductInvestigationScreen extends StatefulWidget {
  final String skinType;
  final List<String> skinConcerns;

  const ProductInvestigationScreen({
    super.key,
    required this.skinType,
    required this.skinConcerns,
  });

  @override
  State<ProductInvestigationScreen> createState() => _ProductInvestigationScreenState();
}

class _ProductInvestigationScreenState extends State<ProductInvestigationScreen> {
  final TextEditingController _productController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  bool _isAnalyzing = false;
  ProductAnalysis? _currentAnalysis;
  File? _productImage;

  Future<void> _takeProductPhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _productImage = File(photo.path);
        });
        _analyzeProduct(source: 'camera');
      }
    } catch (e) {
      _showErrorDialog('Failed to take photo: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _productImage = File(photo.path);
        });
        _analyzeProduct(source: 'gallery');
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  Future<void> _analyzeProduct({String source = 'text'}) async {
    if (_productController.text.trim().isEmpty && _productImage == null) {
      _showErrorDialog('Please enter a product name or take a photo');
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI analysis delay
    await Future.delayed(const Duration(seconds: 3));

    // Mock AI analysis result
    setState(() {
      _currentAnalysis = _generateMockAnalysis();
      _isAnalyzing = false;
    });
  }

  ProductAnalysis _generateMockAnalysis() {
    String productName = _productController.text.isNotEmpty 
        ? _productController.text 
        : 'Scanned Product';

    return ProductAnalysis(
      productName: productName,
      overallRating: 'Good',
      safetyScore: 8.2,
      ingredients: [
        IngredientInfo(
          name: 'Niacinamide',
          safety: 'Safe',
          benefit: 'Reduces oil production, minimizes pores',
          suitableForSkin: widget.skinType == 'Oily' ? 'Excellent' : 'Good',
        ),
        IngredientInfo(
          name: 'Hyaluronic Acid',
          safety: 'Safe',
          benefit: 'Deep hydration, plumps skin',
          suitableForSkin: 'Excellent',
        ),
        IngredientInfo(
          name: 'Fragrance',
          safety: 'Caution',
          benefit: 'Pleasant scent',
          suitableForSkin: widget.skinType == 'Sensitive' ? 'Avoid' : 'Okay',
        ),
        IngredientInfo(
          name: 'Salicylic Acid',
          safety: 'Safe',
          benefit: 'Exfoliates, unclogs pores',
          suitableForSkin: widget.skinType == 'Oily' ? 'Excellent' : 'Good',
        ),
      ],
      recommendation: _getPersonalizedRecommendation(),
      warnings: widget.skinType == 'Sensitive' 
          ? ['Contains fragrance - may cause irritation']
          : [],
    );
  }

  String _getPersonalizedRecommendation() {
    switch (widget.skinType) {
      case 'Oily':
        return 'Great choice for oily skin! The niacinamide and salicylic acid will help control oil and minimize pores.';
      case 'Dry':
        return 'Good for dry skin. The hyaluronic acid provides excellent hydration. Consider using a heavier moisturizer on top.';
      case 'Sensitive':
        return 'Be cautious with this product. It contains fragrance which may irritate sensitive skin. Patch test first.';
      case 'Combination':
        return 'Suitable for combination skin. Use on oily areas, but be gentle around drier zones.';
      default:
        return 'This product appears to be suitable for your skin type based on the ingredient analysis.';
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearAnalysis() {
    setState(() {
      _currentAnalysis = null;
      _productImage = null;
      _productController.clear();
    });
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Investigate Product',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_currentAnalysis != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black87),
              onPressed: _clearAnalysis,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentAnalysis == null) ...[
              // Input Section
              _buildInputSection(),
            ] else ...[
              // Analysis Results
              _buildAnalysisResults(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          width: double.infinity,
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
          child: Column(
            children: [
              const Icon(
                Icons.search,
                size: 48,
                color: Color(0xFF6B73FF),
              ),
              const SizedBox(height: 12),
              const Text(
                'Analyze Any Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get AI-powered analysis for your ${widget.skinType.toLowerCase()} skin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Product Name Input
        const Text(
          'Enter Product Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _productController,
            decoration: const InputDecoration(
              hintText: 'e.g., CeraVe Foaming Cleanser',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            onSubmitted: (_) => _analyzeProduct(),
          ),
        ),

        const SizedBox(height: 24),

        // Camera Options
        const Text(
          'Or Take a Photo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCameraButton(
                icon: Icons.camera_alt,
                title: 'Take Photo',
                onTap: _takeProductPhoto,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCameraButton(
                icon: Icons.photo_library,
                title: 'From Gallery',
                onTap: _pickFromGallery,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Analyze Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isAnalyzing ? null : () => _analyzeProduct(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isAnalyzing
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Analyzing...'),
                    ],
                  )
                : const Text(
                    'Analyze Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),

        if (_productImage != null) ...[
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: FileImage(_productImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCameraButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF6B73FF), size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final analysis = _currentAnalysis!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Header
        Container(
          width: double.infinity,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                analysis.productName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRatingColor(analysis.overallRating).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      analysis.overallRating,
                      style: TextStyle(
                        color: _getRatingColor(analysis.overallRating),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Safety Score: ${analysis.safetyScore}/10',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Recommendation
        if (analysis.recommendation.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'AI Recommendation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  analysis.recommendation,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Warnings
        if (analysis.warnings.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Warnings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...analysis.warnings.map((warning) => Text(
                  '• $warning',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[800],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Ingredients Analysis
        const Text(
          'Ingredient Analysis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...analysis.ingredients.map((ingredient) => _buildIngredientCard(ingredient)),
      ],
    );
  }

  Widget _buildIngredientCard(IngredientInfo ingredient) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                ingredient.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSafetyColor(ingredient.safety).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ingredient.safety,
                  style: TextStyle(
                    color: _getSafetyColor(ingredient.safety),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ingredient.benefit,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'For your skin: ${ingredient.suitableForSkin}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _getSuitabilityColor(ingredient.suitableForSkin),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(String rating) {
    switch (rating.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'okay':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getSafetyColor(String safety) {
    switch (safety.toLowerCase()) {
      case 'safe':
        return Colors.green;
      case 'caution':
        return Colors.orange;
      case 'avoid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getSuitabilityColor(String suitability) {
    switch (suitability.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'okay':
        return Colors.orange;
      case 'avoid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class ProductAnalysis {
  final String productName;
  final String overallRating;
  final double safetyScore;
  final List<IngredientInfo> ingredients;
  final String recommendation;
  final List<String> warnings;

  ProductAnalysis({
    required this.productName,
    required this.overallRating,
    required this.safetyScore,
    required this.ingredients,
    required this.recommendation,
    required this.warnings,
  });
}

class IngredientInfo {
  final String name;
  final String safety;
  final String benefit;
  final String suitableForSkin;

  IngredientInfo({
    required this.name,
    required this.safety,
    required this.benefit,
    required this.suitableForSkin,
  });
} 