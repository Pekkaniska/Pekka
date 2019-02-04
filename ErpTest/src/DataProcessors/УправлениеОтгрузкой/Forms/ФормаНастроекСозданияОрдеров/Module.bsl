
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("МассивРаспоряжений") Тогда
		Распоряжения = Параметры.МассивРаспоряжений;
	Иначе
		Распоряжения = Новый Массив;
	КонецЕсли;
	
	МассивРаспоряжений.ЗагрузитьЗначения(Распоряжения);
	ОформитьРасходныеОрдераНаСервере(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОформленныеРасходныеОрдераВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.РасходныйОрдер);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	Если Элементы.ОформленныеРасходныеОрдера.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, Элементы.ОформленныеРасходныеОрдера.ТекущиеДанные.РасходныйОрдер);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ОформитьРасходныеОрдераНаСервере(Отказ)
	
	ПараметрыПереоформленияРасходныхОрдеров = СкладыСервер.ПараметрыПереоформленияРасходныхОрдеров();
		
	Запрос = Новый Запрос;
	Запрос.Текст =	
	
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.ЗаказНаВнутреннееПотребление КАК ДокументОтгрузки,
	|	ДокументТовары.Ссылка.Склад КАК Склад
	|ПОМЕСТИТЬ ДокументыОтгрузки
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.ПотреблениеПоЗаказам
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЗаказНаВнутреннееПотребление КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.ЗаказНаПеремещение,
	|	ДокументТовары.Ссылка.СкладОтправитель
	|ИЗ
	|	Документ.ПеремещениеТоваров.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.ПеремещениеПоЗаказам
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.СкладОтправитель
	|ИЗ
	|	Документ.ПеремещениеТоваров КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.СкладОтправитель
	|ИЗ
	|	Документ.ЗаказНаПеремещение КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.ЗаказКлиента,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.РеализацияПоЗаказам
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Документ.ЗаказНаСборку,
	|	Документ.Склад
	|ИЗ
	|	Документ.СборкаТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивРаспоряжений)
	|	И Документ.ЗаказНаСборку <> ЗНАЧЕНИЕ(Документ.ЗаказНаСборку.ПустаяСсылка)
	|	И Документ.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Документ.Ссылка,
	|	Документ.Склад
	|ИЗ
	|	Документ.СборкаТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивРаспоряжений)
	|	И Документ.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Документ.Ссылка,
	|	Документ.Склад
	|ИЗ
	|	Документ.ЗаказНаСборку КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивРаспоряжений)
	|	И Документ.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	//++ НЕ УТ
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Распоряжение,
	|	ДокументТовары.Ссылка.Отправитель
	|ИЗ
	|	Документ.ДвижениеПродукцииИМатериалов.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.ПоРаспоряжениям
	|	И ДокументТовары.Ссылка.Проведен
	|	И ДокументТовары.Ссылка.ХозяйственнаяОперация В(
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаМатериаловВПроизводство),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаМатериаловВКладовую))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Отправитель
	|ИЗ
	|	Документ.ДвижениеПродукцииИМатериалов КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Проведен
	|	И ДокументТовары.Ссылка.ХозяйственнаяОперация В(
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаМатериаловВПроизводство),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаМатериаловВКладовую))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Документ.Ссылка,
	|	Документ.Склад
	|ИЗ
	|	Документ.ОтгрузкаТоваровСХранения КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивРаспоряжений)
	|	И Документ.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Распоряжение,
	|	ДокументТовары.Ссылка.Склад
	|ИЗ
	|	Документ.ПередачаМатериаловВПроизводство.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.ПередачаПоРаспоряжениям
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ПередачаМатериаловВПроизводство КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЗаказМатериаловВПроизводство КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.ЗаказПереработчику,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ПередачаСырьяПереработчику.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.ПередачаПоЗаказам
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ПередачаСырьяПереработчику.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЗаказПереработчику.Материалы КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	//++ НЕ УТКА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК ДокументТовары
	|		ПО ЭтапПроизводства.Ссылка = ДокументТовары.Ссылка
	|ГДЕ
	|	ЭтапПроизводства.ЗаказПереработчику В(&МассивРаспоряжений)
	|	И ЭтапПроизводства.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.ЗаказДавальца,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ПередачаДавальцу.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.ПередачаПоЗаказам
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ПередачаДавальцу.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЗаказДавальца.Продукция КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ВозвратСырьяДавальцу КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЗаказНаРемонт.МатериалыИРаботы КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Склад
	|ИЗ
	|	Документ.КорректировкаЗаказаМатериаловВПроизводство.МатериалыИУслуги КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивРаспоряжений)
	|	И ДокументТовары.Ссылка.Проведен
	|
	//-- НЕ УТКА
	//-- НЕ УТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаданиеНаПеревозкуРаспоряжения.Ссылка КАК ЗаданиеНаПеревозку,
	|	ЗаданиеНаПеревозкуРаспоряжения.Распоряжение КАК ДокументОтгрузки,
	|	ЗаданиеНаПеревозкуРаспоряжения.Склад КАК Склад
	|ПОМЕСТИТЬ ДокументыОтгрузкиЗаданияНаПерервозку
	|ИЗ
	|	Документ.ЗаданиеНаПеревозку.Распоряжения КАК ЗаданиеНаПеревозкуРаспоряжения
	|ГДЕ
	|	ЗаданиеНаПеревозкуРаспоряжения.Ссылка В(&МассивРаспоряжений)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗНАЧЕНИЕ(Документ.ЗаданиеНаПеревозку.ПустаяСсылка) КАК ЗаданиеНаПеревозку,
	|	ТоварыКОтгрузке.Склад КАК Склад,
	|	ТоварыКОтгрузке.ДокументОтгрузки КАК ДокументОтгрузки,
	|	ТоварыКОтгрузке.Получатель КАК Получатель,
	|	ЕСТЬNULL(РеквизитыРаспоряжения.ДатаДокументаИБ, ДАТАВРЕМЯ(1,1,1)) КАК Дата
	|ПОМЕСТИТЬ ДанныеДляПереоформленияОрдеров
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке КАК ТоварыКОтгрузке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДокументыОтгрузки КАК ДокументыОтгрузки
	|		ПО ТоварыКОтгрузке.ДокументОтгрузки = ДокументыОтгрузки.ДокументОтгрузки
	|			И ТоварыКОтгрузке.Склад = ДокументыОтгрузки.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеквизитыРаспоряжения
	|			ПО ТоварыКОтгрузке.ДокументОтгрузки = РеквизитыРаспоряжения.Ссылка
	|				И НЕ РеквизитыРаспоряжения.ДополнительнаяЗапись
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументыОтгрузкиЗаданияНаПерервозку.ЗаданиеНаПеревозку,
	|	ТоварыКОтгрузке.Склад,
	|	ТоварыКОтгрузке.ДокументОтгрузки,
	|	ТоварыКОтгрузке.Получатель,
	|	ДокументыОтгрузкиЗаданияНаПерервозку.ЗаданиеНаПеревозку.ДатаВремяРейсаПланС
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке КАК ТоварыКОтгрузке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДокументыОтгрузкиЗаданияНаПерервозку КАК ДокументыОтгрузкиЗаданияНаПерервозку
	|		ПО ТоварыКОтгрузке.ДокументОтгрузки = ДокументыОтгрузкиЗаданияНаПерервозку.ДокументОтгрузки
	|			И ТоварыКОтгрузке.Склад = ДокументыОтгрузкиЗаданияНаПерервозку.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныДляПереофрмленияОррдеров.ЗаданиеНаПеревозку,
	|	ДанныДляПереофрмленияОррдеров.Склад,
	|	ДанныДляПереофрмленияОррдеров.ДокументОтгрузки,
	|	ДанныДляПереофрмленияОррдеров.Получатель
	|ИЗ
	|	ДанныеДляПереоформленияОрдеров КАК ДанныДляПереофрмленияОррдеров
	|ГДЕ
	|	ДанныДляПереофрмленияОррдеров.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|	И ДанныДляПереофрмленияОррдеров.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке <= ДанныДляПереофрмленияОррдеров.Дата";
	
	Запрос.УстановитьПараметр("МассивРаспоряжений", МассивРаспоряжений.ВыгрузитьЗначения());
	
	УстановитьПривилегированныйРежим(Истина);
	ЗапросПакет = Запрос.ВыполнитьПакет();
	Выборка = ЗапросПакет[3].Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	СоздатьОрдера = Ложь; 
	
	Пока Выборка.СледующийПоЗначениюПоля("ЗаданиеНаПеревозку") Цикл
		
		ПараметрыПереоформленияРасходныхОрдеров.ЗаданиеНаПеревозку = Выборка.ЗаданиеНаПеревозку;
		
		Пока Выборка.СледующийПоЗначениюПоля("Склад") Цикл		
			
			СоздатьОрдера = Истина;
			
			ПараметрыПереоформленияРасходныхОрдеров.Склад = Выборка.Склад;
			
			Пока Выборка.СледующийПоЗначениюПоля("Получатель") Цикл	
				
				ПараметрыПереоформленияРасходныхОрдеров.Получатель = Выборка.Получатель;
				
				Распоряжения = Новый Массив;
				Пока Выборка.Следующий() Цикл
					Распоряжения.Добавить(Выборка.ДокументОтгрузки);
				КонецЦикла;
				
				ПараметрыПереоформленияРасходныхОрдеров.РаспоряженияНаОтгрузку = Распоряжения;		
				
				СтруктураЗадания = СкладыСервер.ПереоформитьРасходныеОрдера(ПараметрыПереоформленияРасходныхОрдеров);
				Для Каждого ОформленныеОрдераСтрока Из СтруктураЗадания.ОформленныеОрдера Цикл
					НоваяСтрока = ОформленныеРасходныеОрдера.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ОформленныеОрдераСтрока);
					НоваяСтрока.Получатель = Выборка.Получатель;
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	
	Если Не СоздатьОрдера Тогда
		Отказ = Истина;

		ТекстСообщения = НСтр("ru='По выбранным распоряжениям не требуется отгрузка товаров.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
