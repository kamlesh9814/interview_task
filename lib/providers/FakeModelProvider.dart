import 'package:flutter/material.dart';
import 'package:interview_task/database/DatabaseHelper.dart';
import 'package:interview_task/model/FakeModel.dart';
import 'package:interview_task/repository/FakeRepository.dart';


class FakeModelProvider extends ChangeNotifier {
  final FakeRepository _repository = FakeRepository();
  List<FakeModel> _items = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMoreData = true;

  List<FakeModel> get items => _items;
  bool get hasMoreData => _hasMoreData;

  Future<void> fetchData() async {
    try {
      final fetchedData = await _repository.fetchFakeData();
      _items = fetchedData.take(_pageSize).toList();
      _currentPage = 1;
      _hasMoreData = fetchedData.length > _pageSize;
      for (var item in _items) {
        await DatabaseHelper.instance.insertFakeModel(item);
      }
    } catch (error) {
      _items = await DatabaseHelper.instance.getFakeModels();
    }
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    if (!_hasMoreData) return;

    try {
      final fetchedData = await _repository.fetchFakeData();
      final nextPageData = fetchedData.skip(_currentPage * _pageSize).take(_pageSize).toList();

      if (nextPageData.isNotEmpty) {
        _items.addAll(nextPageData);
        _currentPage++;
      }

      _hasMoreData = nextPageData.length == _pageSize;
    } catch (error) {
      // Handle errors if necessary
    }
    notifyListeners();
  }
}
