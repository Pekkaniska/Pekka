
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатОтчетПоставщикаПЦ.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение.ОтразитьОборотыПоОтчетамПоставщиковПЦ(ДополнительныеСвойства, Движения, Отказ);

	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатОтчетПоставщикаПЦ.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	Если АЗС.ЭтоАЗССклад Тогда
		ИндексКонтрагент = ПроверяемыеРеквизиты.Найти("Контрагент");
		ПроверяемыеРеквизиты.Удалить(ИндексКонтрагент);
	КонецЕсли;
	
	мОтказ = Ложь;
	Для Каждого ТекСтрока Из Заправки Цикл
		Если ТекСтрока.ПластиковаяКарта.ДатаОкончания <> Дата(1,1,1) Тогда
			Если ТекСтрока.ПластиковаяКарта.ДатаОкончания < ТекСтрока.Дата Тогда 
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке("В строке №" + ТекСтрока.НомерСтроки + " топливная карта просрочена", Отказ, Заголовок);
			КонецЕсли;
		КонецЕсли;
		Если ТекСтрока.Количество < 0 ИЛИ ТекСтрока.Сумма < 0 Тогда
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке("В строке №" + ТекСтрока.НомерСтроки + " указано отрицательное значение количества или суммы", мОтказ, Заголовок);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
