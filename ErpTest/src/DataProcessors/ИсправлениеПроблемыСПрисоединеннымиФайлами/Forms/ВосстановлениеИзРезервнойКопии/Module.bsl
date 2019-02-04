
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПолучитьСписокИБ8();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура ТаблицаПутиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ТаблицаПути.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПутьКИБ	= Элементы.ТаблицаПути.ТекущиеДанные.Путь;
	ИмяИБ	= Элементы.ТаблицаПути.ТекущиеДанные.Имя;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВосстановлениеДанныхСтраницы", "ТекущаяСтраница", Элементы.ВосстановлениеДанныхОжидание);
	
	ПодключитьОбработчикОжидания("ВосстановитьДанныеФайловНаКлиенте", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьСписокИБ8()
	
	ТаблицаПути.Очистить();
	
	КаталогДанныхПользователя = "";
	
	#Если ВебКлиент Тогда

		КаталогДанныхПользователя = Вычислить("РабочийКаталогДанныхПользователя()");
		КаталогДанныхПользователя = Сред(КаталогДанныхПользователя, 1, СтрНайти(КаталогДанныхПользователя, "Roaming") + 6);
		
	#Иначе
		Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
			КаталогДанныхПользователя = Вычислить("РабочийКаталогДанныхПользователя()");
			КаталогДанныхПользователя = Сред(КаталогДанныхПользователя, 1, СтрНайти(КаталогДанныхПользователя, "Roaming") + 6);
			
		Иначе
			Оболочка = Новый COMОбъект("WScript.Shell");
			КаталогДанныхПользователя = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
			
		КонецЕсли;
		
	#КонецЕсли
	
	Если Не ЗначениеЗаполнено(КаталогДанныхПользователя) Тогда
		Возврат;
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ВерсияПлатформы = Лев(СистемнаяИнформация.ВерсияПриложения, 3);
	
	Если ВерсияПлатформы = "8.1" Тогда
		ЛокальныеИБ	= КаталогДанныхПользователя + "\1C\1Cv81\ibases.v8i";
		ОбщиеИБ		= КаталогДанныхПользователя + "\1C\1Cv81\ibases.v8l";
		
	Иначе
		ЛокальныеИБ	= КаталогДанныхПользователя + "\1C\1CEStart\ibases.v8i";
		ОбщиеИБ		= КаталогДанныхПользователя + "\1C\1CEStart\ibases.v8l";
		
	КонецЕсли;
	
	Файл = Новый Файл(ЛокальныеИБ);
	Если Файл.Существует() Тогда
		ПрочитатьСписокБаз(ВерсияПлатформы, ЛокальныеИБ);
	КонецЕсли;
	
	Файл = Новый Файл(ОбщиеИБ);
	Если Файл.Существует() Тогда
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ОбщиеИБ);
		
		Для НомерСтроки = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
			ОбщаяИБ = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
			Файл = Новый Файл(ОбщаяИБ);
			Если Файл.Существует() Тогда
				ПрочитатьСписокБаз(ВерсияПлатформы, ОбщаяИБ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаПути.Сортировать("Имя");
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьСписокБаз(ВерсияПлатформы, ПутьКФайлу)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ПутьКФайлу);
	
	КоличествоСтрок = ТекстовыйДокумент.КоличествоСтрок();
	Для НомерСтроки = 1 По КоличествоСтрок Цикл
		ИмяИБ	= "";
		ПутьИБ	= "";
		Папка	= "";
		
		ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		Если Лев(ТекущаяСтрока,1) = "[" И Прав(ТекущаяСтрока,1) = "]" Тогда
			ИмяИБ = Сред(ТекущаяСтрока,2,СтрДлина(ТекущаяСтрока)-2);
			НомерСтроки = НомерСтроки + 1;
			ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
			Если СтрНайти(ТекущаяСтрока, "Connect=File=") <> 0 Тогда
				ПутьИБ = Сред(ТекущаяСтрока, 9, СтрДлина(ТекущаяСтрока)- 9);
				
				НоваяСтрока = ТаблицаПути.Добавить();
				НоваяСтрока.Имя		= ИмяИБ;
				НоваяСтрока.Путь	= ПутьИБ;
				
			ИначеЕсли СтрНайти(ТекущаяСтрока, "Connect=Srvr=") <> 0 Тогда
				ПутьИБ = Сред(ТекущаяСтрока, 9, СтрДлина(ТекущаяСтрока)- 9);
				
				НоваяСтрока = ТаблицаПути.Добавить();
				НоваяСтрока.Имя		= ИмяИБ;
				НоваяСтрока.Путь	= ПутьИБ;
				
			КонецЕсли;
			
			Если НомерСтроки >= КоличествоСтрок Тогда
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьДанныеФайловНаКлиенте()
	
	Отказ = Ложь;
	ВосстановитьДанныеФайлов(Отказ);
	
	Если Не Отказ Тогда 
		Оповестить("ВосстановленыПрисоединенныеФайлыФизическихЛиц", , ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьДанныеФайлов(Отказ)
	
	ИмяCOMСоединителя = ОбщегоНазначенияКлиентСервер.ИмяCOMСоединителя();
	
	// Создание соединения
	Попытка
		ИБИсточник = Новый COMObject(ИмяCOMСоединителя);
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВосстановлениеДанныхСтраницы", "ТекущаяСтраница", Элементы.ВосстановлениеДанныхОшибка);
		ТекстОшибки = Нстр("ru = 'Ошибка создания COM-объекта: %1. Обратитесь к администратору информационной системы.'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	СтрокаПодключения = ПутьКИБ;
	Если ЗначениеЗаполнено(Пользователь) Тогда
		СтрокаПодключения = СтрокаПодключения + ";Usr=""" + Пользователь + """";
	КонецЕсли;
	Если ЗначениеЗаполнено(Пароль) Тогда
		СтрокаПодключения = СтрокаПодключения + ";Pwd=""" + Пароль + """";
	КонецЕсли;
	
	Попытка
		ИБИсточник = ИБИсточник.Connect(СтрокаПодключения);
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВосстановлениеДанныхСтраницы", "ТекущаяСтраница", Элементы.ВосстановлениеДанныхОшибка);
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = Нстр("ru = 'Не удалось подключиться к информационной базе:'");
		ТекстОшибки = ТекстОшибки + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);	
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Файлы.Ссылка
	               |ИЗ
	               |	Справочник.Файлы КАК Файлы
	               |ГДЕ
	               |	Файлы.ВладелецФайла = НЕОПРЕДЕЛЕНО";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокФайлов = ИБИсточник.NewObject("Массив");
	
	Пока Выборка.Следующий() Цикл
		ИдентификаторФайла = ИБИсточник.NewObject("УникальныйИдентификатор", XMLСтрока(Выборка.Ссылка));
		СписокФайлов.Добавить(ИБИсточник.Справочники.Файлы.ПолучитьСсылку(ИдентификаторФайла));
	КонецЦикла;
	
	Запрос = ИБИсточник.NewObject("Запрос");
	
	Запрос.УстановитьПараметр("СписокФайлов", СписокФайлов);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Файлы.Ссылка,
	               |	Файлы.ВладелецФайла
	               |ИЗ
	               |	Справочник.Файлы КАК Файлы
	               |ГДЕ
	               |	Файлы.Ссылка В(&СписокФайлов)";
				   
	Выборка = Запрос.Выполнить().Выбрать();			   
	
	Пока Выборка.Следующий() Цикл
		
		ИдентификаторФайла = Новый УникальныйИдентификатор(ИБИсточник.XMLСтрока(Выборка.Ссылка));
		Файл = Справочники.Файлы.ПолучитьСсылку(ИдентификаторФайла);
		
		ИдентификаторФизическогоЛица = Новый УникальныйИдентификатор(ИБИсточник.XMLСтрока(Выборка.ВладелецФайла));
		ФизическоеЛицо = Справочники.ФизическиеЛица.ПолучитьСсылку(ИдентификаторФизическогоЛица);
		
		НачатьТранзакцию();
		
		Попытка
		
			ФайлОбъект = Файл.ПолучитьОбъект();
			ФайлОбъект.ВладелецФайла = ФизическоеЛицо;
			ФайлОбъект.ОбменДанными.Загрузка = Истина;
			ФайлОбъект.Записать();
			
			ДанныеФайлаИДвоичныеДанные = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИДвоичныеДанные(Файл);
			
			ДанныеФайла = ДанныеФайлаИДвоичныеДанные.ДанныеФайла;
			ДвоичныеДанные = ДанныеФайлаИДвоичныеДанные.ДвоичныеДанные;
			
			ИдентификаторАдресаФайла = Новый УникальныйИдентификатор;
			АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ИдентификаторАдресаФайла);
			
			ПараметрыФайла = Новый Структура;
			ПараметрыФайла.Вставить("Автор", ДанныеФайла.АвторТекущейВерсии);
			ПараметрыФайла.Вставить("ВладелецФайлов", ФизическоеЛицо);
			ПараметрыФайла.Вставить("ИмяБезРасширения", ДанныеФайла.ПолноеНаименованиеВерсии);
			ПараметрыФайла.Вставить("РасширениеБезТочки", ДанныеФайла.Расширение);
			ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ДанныеФайла.ДатаМодификацииУниверсальная);
			
			ПрисоединенныйФайлСсылка = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайлаВоВременномХранилище);
			
			УдалитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
			
		Исключение
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВосстановлениеДанныхСтраницы", "ТекущаяСтраница", Элементы.ВосстановлениеДанныхОшибка);
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке));	
			ОтменитьТранзакцию();
			Отказ = Истина;
			Возврат;
			
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВосстановлениеДанныхСтраницы", "ТекущаяСтраница", Элементы.ВосстановлениеДанныхВыполнено);
	
КонецПроцедуры

#КонецОбласти
