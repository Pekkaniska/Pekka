#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	ТабЧастьДокумента.Ссылка КАК Регистратор,
	|	ТабЧастьДокумента.Ссылка.АЗС КАК АЗС,
	|	ТабЧастьДокумента.Ссылка.Организация КАК Организация,
	|	ТабЧастьДокумента.Ссылка.ВалютаДокумента КАК Валюта,
	|	ТабЧастьДокумента.Дата КАК Период,
	|	ТабЧастьДокумента.Проверено КАК Проверено,
	|	ТабЧастьДокумента.ПластиковаяКартаОтчета КАК ПластиковаяКартаОтчета,
	|	ТабЧастьДокумента.НоменклатураОтчета КАК НоменклатураОтчета,
	|	ТабЧастьДокумента.ТСОтчета КАК ТСОтчета,
	|	ТабЧастьДокумента.ПластиковаяКарта КАК ПластиковаяКарта,
	|	ТабЧастьДокумента.ТС КАК ТС,
	|	ТабЧастьДокумента.ГСМ КАК Номенклатура,
	|	ТабЧастьДокумента.Количество КАК Количество,
	|	ТабЧастьДокумента.Сумма КАК Стоимость,
	|	ТабЧастьДокумента.Сумма КАК СтоимостьУпр
	|ИЗ
	|	Документ.уатОтчетПоставщикаПЦ.Заправки КАК ТабЧастьДокумента
	|ГДЕ
	|	ТабЧастьДокумента.Ссылка = &Ссылка
	|";
	мЗапрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	ТаблицаОборотыПоОтчетамПоставщиковПЦ = мЗапрос.Выполнить().Выгрузить();
	
	Для Каждого ТекСтрока ИЗ ТаблицаОборотыПоОтчетамПоставщиковПЦ Цикл
		мКурсВалютыСтруктура = уатОбщегоНазначенияТиповые.ПолучитьКурсВалюты(ДокументСсылка.ВалютаДокумента, ТекСтрока.Период);
		
		Если СтруктураДополнительныеСвойства.ВалютаРеглУчета <> ДокументСсылка.ВалютаДокумента тогда
			ТекСтрока.Стоимость = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.Стоимость, ДокументСсылка.ВалютаДокумента, 
		   						СтруктураДополнительныеСвойства.ВалютаРеглУчета,
								мКурсВалютыСтруктура.Курс, 
								СтруктураДополнительныеСвойства.КурсРегл,
								мКурсВалютыСтруктура.Кратность,  
								СтруктураДополнительныеСвойства.КратностьРегл);
		КонецЕсли;
		
		Если СтруктураДополнительныеСвойства.Свойство("ВалютаУпрУчета") И СтруктураДополнительныеСвойства.ВалютаУпрУчета <> ДокументСсылка.ВалютаДокумента тогда
			ТекСтрока.СтоимостьУпр = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.СтоимостьУпр, ДокументСсылка.ВалютаДокумента,
								СтруктураДополнительныеСвойства.ВалютаУпрУчета, 
								мКурсВалютыСтруктура.Курс, 
								СтруктураДополнительныеСвойства.КурсУпр,
								мКурсВалютыСтруктура.Кратность,  
								СтруктураДополнительныеСвойства.КратностьУпр);
		Иначе
			ТекСтрока.СтоимостьУпр = 0;								
		КонецЕсли;
	КонецЦикла;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОборотыПоОтчетамПоставщиковПЦ", ТаблицаОборотыПоОтчетамПоставщиковПЦ);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	//зарезервировано
КонецПроцедуры // ВыполнитьКонтроль()

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Заглушка = Истина;
КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	Заглушка = Истина;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецЕсли