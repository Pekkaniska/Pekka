
//////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатВводНачальныхПоказаний.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение.ОтразитьСчетчикиТС(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатВводНачальныхПоказаний.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Заголовок = "Проведение документа " + Ссылка;
	СтруктураПолей = Новый Структура("ТС");
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Спидометр", СтруктураПолей, Отказ,
																	Заголовок);
	
	//проверка на дубли строк
	Если НЕ Отказ Тогда
		тблСпидометр = Спидометр.Выгрузить().Скопировать();
		тблСпидометр.Свернуть("ТС");
		Если тблСпидометр.Количество() < Спидометр.Количество() Тогда
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке("В табличной части присутствуют повторяющиеся строки (дублирование ТС)!", Отказ,
												Заголовок);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
