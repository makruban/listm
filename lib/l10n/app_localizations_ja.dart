// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'TripWiseへようこそ';

  @override
  String get packingLists => 'パッキングリスト';

  @override
  String get allItems => 'すべてのアイテム';

  @override
  String get addPackingList => 'パッキングリストを追加';

  @override
  String get addItem => 'アイテムを追加';

  @override
  String get noTripsMessage => 'パッキングリストが見つかりません。+をタップして追加してください。';

  @override
  String tripsLoadError(Object error) {
    return 'パッキングリストの読み込みに失敗しました：$error';
  }

  @override
  String get untitledTrip => '無題の旅行';

  @override
  String get itemsLabel => 'アイテム';

  @override
  String get renameAction => '名前を変更';

  @override
  String get infoAction => '情報';

  @override
  String get deleteAction => '削除';

  @override
  String get tripDetailsTitle => '旅行の詳細';

  @override
  String tripTitleLabel(Object title) {
    return 'タイトル: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => '閉じる';

  @override
  String get removeAction => '削除';

  @override
  String get onboardingTitle1 => '旅行の計画を立てる';

  @override
  String get onboardingDesc1Part1 => '';

  @override
  String get onboardingDesc1Part2 => ' ボタンをクリックして旅行を作成します';

  @override
  String get onboardingTitle2 => '忘れ物をなくす';

  @override
  String get onboardingDesc2 => 'アイテムを管理し、旅行に必要なものがすべて揃っていることを確認します。';

  @override
  String get onboardingTitle3 => '出発の準備完了';

  @override
  String get onboardingDesc3 => '完璧に準備が整った安心感とともに旅行をお楽しみください。';

  @override
  String get skipButton => 'スキップ';

  @override
  String get nextButton => '次へ';

  @override
  String get doneButton => '完了';

  @override
  String get noTripsMessageTitle => 'パッキングリストが見つかりません';

  @override
  String get noTripsMessageSub => '+をタップして追加してください。';

  @override
  String get deleteItemTitle => 'アイテムを削除';

  @override
  String deleteItemConfirmation(Object title) {
    return '\"$title\" を削除してもよろしいですか？';
  }

  @override
  String get itemUsedInTripsWarning => '注意！このアイテムは次の旅行で使用されています：';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get deleteButton => '削除';

  @override
  String itemsLoadError(Object error) {
    return 'エラー：$error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'アイテム $index';
  }

  @override
  String get itemDetailsTitle => 'アイテムの詳細';

  @override
  String itemTitleLabel(Object title) {
    return 'タイトル：$title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID：$id';
  }

  @override
  String get notPackedLabel => '未梱包';

  @override
  String get emptyInventoryTitle => 'インベントリは空です';

  @override
  String get emptyInventorySub => '+をタップしてアイテムの追加を開始します';

  @override
  String get tripTitleHint => '旅行のタイトル';

  @override
  String get tripDetailsNavTitle => '旅行の詳細';

  @override
  String get clearAllButton => 'すべてクリア';

  @override
  String get clearButton => 'クリア';

  @override
  String get noItemsInTrip => 'この旅行にはアイテムがありません';

  @override
  String get addItemsTitle => 'アイテムを追加';

  @override
  String get createNewItem => '新しいアイテムを作成';

  @override
  String get noItemsAvailableToAdd => '追加できるアイテムがありません';

  @override
  String tripDetailsError(Object error) {
    return 'エラー: $error';
  }

  @override
  String get itemNameLabel => 'アイテム名';

  @override
  String get itemNameHint => '例: 歯ブラシ';

  @override
  String get createButton => '作成';

  @override
  String get congratulationsTitle => 'おめでとうございます！';

  @override
  String get congratulationsMessage => 'すべてのアイテムが梱包されました！出発の準備は完了です！';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => '新しい旅行';

  @override
  String get settings => '設定';

  @override
  String get preferences => '環境設定';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get selectThemeMode => 'Select Theme Mode';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';
}
