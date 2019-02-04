#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция определяет Терминал, Датчик и КалибровочныйГрафик для переданного объекта.
//
Функция ПолучитьПараметрыДатчикаТоплива(ТекущийОбъект, Назначение) Экспорт
	
	Результат = Новый Структура("Терминал,Датчик,КалибровочныйГрафик", 
		Справочники.ItobТерминалы.ПустаяСсылка(), Справочники.ItobДатчики.ПустаяСсылка(),
		                            Справочники.ItobКалибровочныеГрафики.ПустаяСсылка());
	
	Терминал = ItobОперативныйМониторингКлиентСервер.ПолучитьПривязанныйТерминал(ТекущийОбъект,НачалоДня(НачПериода)-1);
	Если НЕ ЗначениеЗаполнено(Терминал) Тогда
		Возврат Результат;		
	
	КонецЕсли;
	
	Результат.Терминал = Терминал;
	
	СтрокаДатчики = Терминал.Датчики.Найти(Назначение,"Назначение");
	Если СтрокаДатчики = Неопределено Тогда
		Возврат Результат;	
	
	КонецЕсли;
	
	Результат.Датчик = СтрокаДатчики.Датчик;	
	Результат.КалибровочныйГрафик = СтрокаДатчики.КалибровочныйГрафик;	
	
	Возврат Результат;	

КонецФункции // ПолучитьПараметрыДатчикаТоплива()

// Функция выполняет формирование табличного документа отчета по топливу.
//
Функция СформироватьОтчетПоТопливу(НачПериода, КонПериода, Метод, Объект, Назначение)
	
	Перем ТаблицаДанные, ТаблицаЗаправки, ТекстОшибки;
	
	ТабДокумент = Новый ТабличныйДокумент;	
	Макет = ПолучитьМакет("Макет");
	
	ПараметрыДатчикаТоплива = ПолучитьПараметрыДатчикаТоплива(Объект, Назначение);
	Терминал            = ПараметрыДатчикаТоплива.Терминал;
	КалибровочныйГрафик = ПараметрыДатчикаТоплива.КалибровочныйГрафик;
	
	Если НЕ ЗначениеЗаполнено(Терминал) Тогда
		ТекстОшибки = НСтр("ru = 'К объекту не привязан терминал!'");
		Возврат ТабДокумент;
	КонецЕсли;
			
	Если НЕ ЗначениеЗаполнено(КалибровочныйГрафик) И НЕ Назначение = "ПоВсем"  Тогда
		ТекстОшибки = НСтр("ru = 'Для терминала объекта не указан калибровочный график!'");
		Возврат ТабДокумент;	
	
	КонецЕсли;
		
	ТекстОшибки = "";
	пПараметры = Новый Структура;
	пПараметры.Вставить("НачПериода", 	НачПериода);
	пПараметры.Вставить("КонПериода ", 	КонПериода);
	пПараметры.Вставить("Объект", 		Объект);
	пПараметры.Вставить("Метод", 		Метод);
	Если НЕ ItobОбработкаДанныхТопливоВызовСервера.ПолучитьДанныеТопливо(пПараметры, ТаблицаДанные, ТаблицаЗаправки, ТекстОшибки, ДатчикТоплива) Тогда
	 	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат ТабДокумент;		
	КонецЕсли;	
			
	ТекстовыйДок = Новый ТекстовыйДокумент;
	ТекстовыйДок.ДобавитьСтроку("#Series1");
	ТекстовыйДок.ДобавитьСтроку(""+Формат(ТаблицаДанные.Количество(),
	                            "ЧРД=.; ЧН=0; ЧГ=0")+";float;float");	
	Для Каждого СтрДанных Из ТаблицаДанные Цикл
		ТекущаяСтрокаДанных = Формат(СтрДанных.Пробег,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0; ЧГ=0")
			+";"+Формат(СтрДанных.ЗначениеСглаженное,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0; ЧГ=0")+";"""+Формат(СтрДанных.Период,"ДФ='dd.MM.yy HH:mm'")+"""";
		ТекстовыйДок.ДобавитьСтроку(ТекущаяСтрокаДанных);					
	
	КонецЦикла;
	ИмяВременногоФайла = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор()) + ".txt";
	ТекстовыйДок.Записать(ИмяВременногоФайла, "windows-1251");
		
	ИмяФайлаКартинки = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор()) + ".png";
	ОбластьШапка     = Макет.ПолучитьОбласть("Шапка");
	ОбластьГрафик = Макет.ПолучитьОбласть("График");
	
	АдресСервераРендеринга = ПараметрыСеанса.ItobАдресCsmSvc.Получить("СерверАдрес")
		+ ":" + Формат(ПараметрыСеанса.ItobАдресCsmSvc.Получить("СерверПорт"),"ЧГ=0");
		
	ОшибкаЗапросаНаСервер = Ложь;
	
	Если НЕ ПараметрыСеанса.ItobАдресCsmSvc.Получить("НастройкиОпределены") Тогда
		ОшибкаЗапросаНаСервер = Истина;
		ОписаниеОшибки = НСтр("ru = 'В настройках системы не указан адрес сервиса CsmSvc!
						 |Воспользуйтесь мастером настройки службы CsmSvc.'");
		
	ИначеЕсли  НЕ ItobОперативныйМониторингКлиентСервер.ПроверитьДоступностьСервисаCsmSvc(АдресСервераРендеринга) Тогда
		ОшибкаЗапросаНаСервер = Истина;
		ОписаниеОшибки = НСтр("ru = 'Сервис CsmSvc не доступен!
						 |Воспользуйтесь мастером настройки службы CsmSvc.'");
		
	Иначе
 		
		Если Прав(АдресСервераРендеринга,1) = "/" Тогда
			АдресСервераРендеринга = Сред(АдресСервераРендеринга,1,СтрДлина(АдресСервераРендеринга)-1);			
		КонецЕсли;
		
		Попытка
			ШиринаРисунка = Формат(Цел(ОбластьГрафик.Рисунки.ImageChart.Ширина*1.8),"ЧГ=0");
			ВысотаРисунка = Формат(Цел(ОбластьГрафик.Рисунки.ImageChart.Высота*1.8),"ЧГ=0");		
			
			Соединение = Новый HTTPСоединение(АдресСервераРендеринга);	
			Соединение.ОтправитьДляОбработки(ИмяВременногоФайла, "RenderChart?Width="+ШиринаРисунка+"&Height="+ВысотаРисунка, ИмяФайлаКартинки);	
			
			УдалитьФайлы(ИмяВременногоФайла);
			
			КартинкаГрафик = Новый Картинка(ИмяФайлаКартинки);
			
			ОбластьГрафик.Рисунки.ImageChart.Картинка = КартинкаГрафик;
						
			УдалитьФайлы(ИмяФайлаКартинки);
			
		Исключение
			
			ОшибкаЗапросаНаСервер = Истина;
			ОписаниеОшибки = НСтр("ru = 'Ошибка рендеринга графика:'")+" "+ОписаниеОшибки();	
			
		КонецПопытки;
	
	КонецЕсли;
		
	ТабДокумент.Очистить();
	
	ТабДокумент.ИмяПараметровПечати = "ItobОтчетПоТопливу_ИмяПараметровПечати";
			
	ОбластьШапка        = Макет.ПолучитьОбласть("Шапка");
	ОбластьДетали       = Макет.ПолучитьОбласть("Детали");
	ОбластьИтоги = Макет.ПолучитьОбласть("ИтогСтрока");
	ОбластьШапкаТЧ = Макет.ПолучитьОбласть("ШапкаТЧ");
	ОблИтоговыеПоказатели = Макет.ПолучитьОбласть("ИтоговыеПоказатели");
	
	ОбластьШапка.Параметры.ЗаголовокОтчета = НСтр("ru = 'Отчет по топливу за'")+" "+НачПериода+" - "+КонПериода;
	ОбластьШапка.Параметры.Объект = НСтр("ru = 'Объект мониторинга:'")+" "+Объект;
	
	ТабДокумент.Вывести(ОбластьШапка);
	

	Если ОшибкаЗапросаНаСервер Тогда
	
		ОбластьОшибка = Макет.ПолучитьОбласть("Ошибка");
		ОбластьОшибка.Параметры.ТекстОшибки = ОписаниеОшибки;
		ОбластьОшибка.Параметры.Расшифровка = Новый Структура("Действие","ОткрытьМастерНастройкиCsmSvc");
		ТабДокумент.Вывести(ОбластьОшибка);	
	Иначе
		ТабДокумент.Вывести(ОбластьГрафик);
	КонецЕсли;

	
	ТабДокумент.Вывести(ОбластьШапкаТЧ);
	
	НомерПП = 1;
	
	ИтогоТопливоПриход = 0;
	ИтогоТопливоРасход = 0;
	
	Для Каждого СтрСливыЗаправки Из ТаблицаЗаправки Цикл
		
		ОбластьДетали.Параметры.НомерПП = НомерПП;
		ОбластьДетали.Параметры.Период = Формат(СтрСливыЗаправки.Период,"ДФ='dd.MM.yyyy HH:mm'");
		ОбластьДетали.Параметры.ТопливоНач = СтрСливыЗаправки.ТопливоНачало;
		ОбластьДетали.Параметры.ТопливоКон = СтрСливыЗаправки.ТопливоКонец;
		ОбластьДетали.Параметры.ТопливоПриход = ?(СтрСливыЗаправки.ТопливоИзменение >= 0, СтрСливыЗаправки.ТопливоИзменение, 0);
		ОбластьДетали.Параметры.ТопливоРасход = ?(СтрСливыЗаправки.ТопливоИзменение < 0, -СтрСливыЗаправки.ТопливоИзменение, 0);
				
		ОбластьДетали.Параметры.Место = ItobОперативныйМониторингКлиентСервер.НайтиБлижайшийАдрес
		                          (СтрСливыЗаправки.Широта, СтрСливыЗаправки.Долгота);
		
		ОбластьДетали.Параметры.Расшифровка = Новый Структура("НачПериода,КонПериода,Объект",
		        НачалоДня(СтрСливыЗаправки.Период),КонецДня(СтрСливыЗаправки.Период),Объект);
		
		ТабДокумент.Вывести(ОбластьДетали);
		
		НомерПП = НомерПП + 1;
		ИтогоТопливоПриход = ИтогоТопливоПриход + ?(СтрСливыЗаправки.ТопливоИзменение >= 0, СтрСливыЗаправки.ТопливоИзменение, 0);
		ИтогоТопливоРасход = ИтогоТопливоРасход + ?(СтрСливыЗаправки.ТопливоИзменение < 0, -СтрСливыЗаправки.ТопливоИзменение, 0);
		
	КонецЦикла;		
	
	ОбластьИтоги.Параметры.ТопливоПриход = Окр(ИтогоТопливоПриход,0);
	ОбластьИтоги.Параметры.ТопливоРасход = Окр(ИтогоТопливоРасход,0);
	ТабДокумент.Вывести(ОбластьИтоги);
	
	// вычисление итоговых показателей по топливу
	
	// ОбъемНаНачало
	МассивДанныхТопливо = ТаблицаДанные.ВыгрузитьКолонку("ЗначениеСглаженное");
	iRes = -1;
	МассивДанныхНач = ItobОбработкаДанныхТопливоВызовСервера.ВыделитьЧастьМассива(МассивДанныхТопливо,3,3,iRes);
	ОбъемНаНачало = ItobОбработкаДанныхТопливоВызовСервера.ПолучитьМедиану(МассивДанныхНач);
	
	Если Метод="Пробег" Тогда
		ТаблицаИнтервалыДвижения = ItobОперативныйМониторинг.ПолучитьИнтервалыДвижения(Объект, НачПериода, КонПериода);
		ПробегОбщий = ТаблицаИнтервалыДвижения.Итог("Пробег");
	Иначе
		ПробегОбщий = ТаблицаДанные[ТаблицаДанные.Количество()-1].Пробег;
	
	КонецЕсли;
	
	
	ОбъемНаКонец = ТаблицаДанные[ТаблицаДанные.Количество()-1].ЗначениеСглаженное;
	ОбщийРасходТоплива = ОбъемНаНачало-ОбъемНаКонец+ИтогоТопливоПриход-ИтогоТопливоРасход;
	
	ОблИтоговыеПоказатели.Параметры.ОбъемНаНачало = Окр(ОбъемНаНачало,0);
	ОблИтоговыеПоказатели.Параметры.ОбъемНаКонец = Окр(ОбъемНаКонец,0);
	ОблИтоговыеПоказатели.Параметры.ОбщийРасходТоплива = Окр(ОбщийРасходТоплива,0);
	ОблИтоговыеПоказатели.Параметры.Пробег = ПробегОбщий;
	ОблИтоговыеПоказатели.Параметры.ПробегТекст = ?(Метод = "Пробег","Пробег, км:","Моточасы:");
	ОблИтоговыеПоказатели.Параметры.СредКоэффициентРасхода = ?(ПробегОбщий<0.1,"Неопределено", ОбщийРасходТоплива/(ПробегОбщий/?(Метод="Пробег",100,1)));
	ОблИтоговыеПоказатели.Параметры.РасходТекст = ?(Метод = "Пробег",
													НСтр("ru = 'Средний расход, л/100км:'"),
													НСтр("ru = 'Средний расход, л/час:'"));	
	
	ТабДокумент.Вывести(ОблИтоговыеПоказатели);
	
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура обработчик события "ПриКомпоновкеРезультата" объекта.
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	
	ДокументРезультат.Вывести(СформироватьОтчетПоТопливу(
		НачПериода,
		КонПериода,
		Метод,
		Объект,
		ДатчикТоплива));
				
КонецПроцедуры // ПриКомпоновкеРезультата()

// Процедура - обработчик события "ОбработкаПроверкиЗаполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НачПериода > КонПериода Тогда
		ТекстОшибки = НСтр("ru='Начало периода не может быть больше даты конца периода'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			Неопределено, // ОбъектИлиСсылка
			"ItobОтчетПоТопливу",
			"Отчет", // ПутьКДанным
			Отказ);
	КонецЕсли;
		
КонецПроцедуры // ОбработкаПроверкиЗаполнения()
	
#КонецОбласти

#КонецЕсли