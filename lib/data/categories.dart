import 'package:flutter/material.dart';
import '../models/word_category.dart';

const List<WordCategoryMeta> kCategoryMetas = [
  WordCategoryMeta(id: 'animals', icon: Icons.pets),
  WordCategoryMeta(id: 'movies', icon: Icons.movie),
  WordCategoryMeta(id: 'series', icon: Icons.tv),
  WordCategoryMeta(id: 'objects', icon: Icons.category),
  WordCategoryMeta(id: 'historyScience', icon: Icons.science),
  WordCategoryMeta(id: 'colorsShapes', icon: Icons.palette),
  WordCategoryMeta(id: 'animalsEasy', icon: Icons.cruelty_free),
  WordCategoryMeta(id: 'numbers', icon: Icons.numbers),
];

const List<String> kNormalCategoryIds = ['animals', 'movies', 'series', 'objects'];
