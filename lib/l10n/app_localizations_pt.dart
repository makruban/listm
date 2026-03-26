// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Bem-vindo ao TripWise';

  @override
  String get packingLists => 'Listas de bagagem';

  @override
  String get allItems => 'Todos os itens';

  @override
  String get addPackingList => 'Adicionar lista';

  @override
  String get addItem => 'Adicionar item';

  @override
  String get noTripsMessage =>
      'Nenhuma lista encontrada. Toque em + para adicionar uma.';

  @override
  String tripsLoadError(Object error) {
    return 'Falha ao carregar listas: $error';
  }

  @override
  String get untitledTrip => 'Viagem sem título';

  @override
  String get itemsLabel => 'itens';

  @override
  String get renameAction => 'Renomear';

  @override
  String get infoAction => 'Info';

  @override
  String get deleteAction => 'Excluir';

  @override
  String get tripDetailsTitle => 'Detalhes da viagem';

  @override
  String tripTitleLabel(Object title) {
    return 'Título: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => 'Fechar';

  @override
  String get removeAction => 'Remover';

  @override
  String get onboardingTitle1 => 'Planeje suas viagens';

  @override
  String get onboardingDesc1Part1 => 'Crie uma viagem clicando no botão ';

  @override
  String get onboardingDesc1Part2 => '';

  @override
  String get onboardingTitle2 => 'Nunca esqueça um item';

  @override
  String get onboardingDesc2 =>
      'Acompanhe seus itens e garanta que você tem tudo que precisa.';

  @override
  String get onboardingTitle3 => 'Pronto para decolar';

  @override
  String get onboardingDesc3 =>
      'Aproveite sua viagem com a paz de espírito de estar preparado.';

  @override
  String get skipButton => 'Pular';

  @override
  String get nextButton => 'Próximo';

  @override
  String get doneButton => 'Concluído';

  @override
  String get noTripsMessageTitle => 'Nenhuma lista encontrada';

  @override
  String get noTripsMessageSub => 'Toque em + para adicionar uma.';

  @override
  String get deleteItemTitle => 'Excluir Item';

  @override
  String deleteItemConfirmation(Object title) {
    return 'Tem certeza que deseja excluir \"$title\"?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'Atenção! Este item é usado em Viagem(ns):';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get deleteButton => 'Excluir';

  @override
  String itemsLoadError(Object error) {
    return 'Erro: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Item $index';
  }

  @override
  String get itemDetailsTitle => 'Detalhes do item';

  @override
  String itemTitleLabel(Object title) {
    return 'Título: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get notPackedLabel => 'Não embalado';

  @override
  String get emptyInventoryTitle => 'Seu inventário está vazio';

  @override
  String get emptyInventorySub => 'Toque em + para começar a adicionar itens';

  @override
  String get tripTitleHint => 'Título da viagem';

  @override
  String get tripDetailsNavTitle => 'Detalhes da viagem';

  @override
  String get clearAllButton => 'Limpar tudo';

  @override
  String get clearButton => 'Limpar';

  @override
  String get noItemsInTrip => 'Nenhum item nesta viagem';

  @override
  String get addItemsTitle => 'Adicionar Itens';

  @override
  String get createNewItem => 'Criar Novo Item';

  @override
  String get noItemsAvailableToAdd => 'Nenhum item disponível para adicionar';

  @override
  String tripDetailsError(Object error) {
    return 'Erro: $error';
  }

  @override
  String get itemNameLabel => 'Nome do item';

  @override
  String get itemNameHint => 'ex., Escova de dente';

  @override
  String get createButton => 'Criar';

  @override
  String get congratulationsTitle => 'Parabéns!';

  @override
  String get congratulationsMessage =>
      'Todos os itens estão arrumados! Você está pronto para ir!';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => 'Nova Viagem';

  @override
  String get settings => 'Configurações';

  @override
  String get preferences => 'Preferências';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get themeMode => 'Modo de Tema';

  @override
  String get selectThemeMode => 'Selecionar Modo de Tema';

  @override
  String get themeSystem => 'Padrão do sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';
}
