////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// настройка типов для полей ввода ОбъектИсточник и ОбъектПриемник
&НаКлиенте
Процедура НастроитьТипы()
	МассивТипов = Новый Массив;
	Если ТипОбъекта = ПредопределенноеЗначение("Перечисление.уатНазначениеПравИНастроек.Организация") Тогда
		МассивТипов.Добавить(Тип("СправочникСсылка.Организации"));
	ИначеЕсли ТипОбъекта = ПредопределенноеЗначение("Перечисление.уатНазначениеПравИНастроек.Пользователь") Тогда
		МассивТипов.Добавить(Тип("СправочникСсылка.Пользователи"));
	ИначеЕсли ТипОбъекта = ПредопределенноеЗначение("Перечисление.уатНазначениеПравИНастроек.Подразделение") Тогда
		МассивТипов.Добавить(Тип("СправочникСсылка.СтруктураПредприятия"));
	Иначе
		ТипОбъекта = ПредопределенноеЗначение("Перечисление.уатНазначениеПравИНастроек.Пользователь");
		МассивТипов.Добавить(Тип("СправочникСсылка.Пользователи"));
		ОбъектИсточник = Неопределено;
		ОбъектПриемник = Неопределено;
	КонецЕсли;
	Описание = Новый ОписаниеТипов(МассивТипов);
	Элементы.ОбъектИсточник.ОграничениеТипа = Описание;
	ОбъектИсточник = Описание.ПривестиЗначение(ОбъектИсточник);
	Элементы.ОбъектПриемник.ОграничениеТипа = Описание;
	ОбъектПриемник = Описание.ПривестиЗначение(ОбъектПриемник);
КонецПроцедуры

// копирование набора прав для другого пользователя/организации/подразделения
&НаСервереБезКонтекста
Процедура СкопироватьНаборПрав(ОбъектИсточник, ОбъектПриемник) Экспорт
	НаборИсточник = РегистрыСведений.уатПраваИНастройки.СоздатьНаборЗаписей();
	НаборИсточник.Отбор.Объект.Установить(ОбъектИсточник);
	НаборИсточник.Прочитать();
	НаборПриемник = РегистрыСведений.уатПраваИНастройки.СоздатьНаборЗаписей();
	НаборПриемник.Отбор.Объект.Установить(ОбъектПриемник);
	НаборПриемник.Очистить();
	Для Каждого Запись Из НаборИсточник Цикл
		НоваяЗапись = НаборПриемник.Добавить();
		НоваяЗапись.Объект = ОбъектПриемник;
		НоваяЗапись.ПравоНастройка = Запись.ПравоНастройка;
		НоваяЗапись.Значение = Запись.Значение;
	КонецЦикла;
	НаборПриемник.Записать();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(ОбъектИсточник) Тогда
		ПоказатьПредупреждение(Неопределено, "Объект источник не выбран!");
		Возврат;
	КонецЕсли;
	Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(ОбъектПриемник) Тогда
		ПоказатьПредупреждение(Неопределено, "Объект приемник не выбран!");
		Возврат;
	КонецЕсли;
	Если ОбъектИсточник = ОбъектПриемник Тогда
		ПоказатьПредупреждение(Неопределено, "Объект источник и объект приемник совпадают!");
		Возврат;
	КонецЕсли;
	
	СкопироватьНаборПрав(ОбъектИсточник, ОбъектПриемник);
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Организация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ТекущийПользователь, "ОсновнаяОрганизация");
	
	Если ОбъектПриемник = ТекущийПользователь ИЛИ ОбъектПриемник = Организация ИЛИ ОбъектПриемник = Неопределено Тогда
		Состояние("Обновление прав текущего пользователя ...");
		ОбновитьПовторноИспользуемыеЗначения();
		ВладелецФормы.ФормированиеДереваПравОбъекта();
	КонецЕсли; 
	
	Сообщить("Набор прав объекта """ + Строка(ОбъектИсточник) + """ скопирован объекту """ + Строка(ОбъектПриемник) + """.");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМЫ

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	НастроитьТипы();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Автотест = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ОбъектИсточник") Тогда
		ОбъектИсточник = Параметры.ОбъектИсточник;
	КонецЕсли;
	Если Параметры.Свойство("ТипОбъекта") Тогда
		ТипОбъекта = Параметры.ТипОбъекта;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Автотест Тогда
		Возврат;
	КонецЕсли;
	
	Если ВладелецФормы = Неопределено Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(Неопределено, "Непосредственное открытие для данного объекта запрещено!", 10);
		Возврат;
	КонецЕсли;
	
	НастроитьТипы();
КонецПроцедуры
