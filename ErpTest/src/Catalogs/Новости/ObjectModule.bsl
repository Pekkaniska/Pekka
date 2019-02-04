#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Удалить лишние и двойные пробелы (whitespace = collapse).
	Наименование               = СокрЛП(СтрЗаменить(Наименование, "  ", " "));
	Подзаголовок               = СокрЛП(СтрЗаменить(Подзаголовок, "  ", " "));
	СсылкаНаПолныйТекстНовости = СокрЛП(СтрЗаменить(СсылкаНаПолныйТекстНовости, "  ", " "));

	Если ПустаяСтрока(Подзаголовок) Тогда
		Подзаголовок = Наименование;
	КонецЕсли;

	// Удалить лишние и двойные пробелы (whitespace = collapse).
	Для Каждого ТекущееДействие Из Действия Цикл
		ТекущееДействие.УИНДействия = СокрЛП(СтрЗаменить(ТекущееДействие.УИНДействия, "  ", " "));
	КонецЦикла;
	Для Каждого ТекущийПараметрДействия Из ПараметрыДействий Цикл
		ТекущийПараметрДействия.УИНДействия = СокрЛП(СтрЗаменить(ТекущийПараметрДействия.УИНДействия, "  ", " "));
	КонецЦикла;
	Для Каждого ТекущиеБинарныеДанные Из БинарныеДанные Цикл
		ТекущиеБинарныеДанные.УИН            = СокрЛП(СтрЗаменить(ТекущиеБинарныеДанные.УИН, "  ", " "));
		ТекущиеБинарныеДанные.Заголовок      = СокрЛП(СтрЗаменить(ТекущиеБинарныеДанные.Заголовок, "  ", " "));
		ТекущиеБинарныеДанные.ИнтернетСсылка = СокрЛП(СтрЗаменить(ТекущиеБинарныеДанные.ИнтернетСсылка, "  ", " "));
	КонецЦикла;
	Для Каждого ТекущаяПривязкаКМетаданным Из ПривязкаКМетаданным Цикл
		ТекущаяПривязкаКМетаданным.Метаданные = СокрЛП(СтрЗаменить(ТекущаяПривязкаКМетаданным.Метаданные, "  ", " "));
		ТекущаяПривязкаКМетаданным.Форма      = СокрЛП(СтрЗаменить(ТекущаяПривязкаКМетаданным.Форма, "  ", " "));
		ТекущаяПривязкаКМетаданным.Событие    = СокрЛП(СтрЗаменить(ТекущаяПривязкаКМетаданным.Событие, "  ", " "));
	КонецЦикла;

	// Дата публикации не может быть раньше 01/01/2014.
	Если ДатаПубликации <= '20140101000000' Тогда
		ДатаПубликации = '20140101000000';
	КонецЕсли;

	Если Важность = 1 Тогда // Очень важная.
		Если (ДатаСбросаВажности = '00010101') Тогда
			ДатаСбросаВажности = ТекущаяУниверсальнаяДата() + 7*24*60*60; // + 1 неделя
		КонецЕсли;
	КонецЕсли;

	// Новость могли изменить - установить важность, поэтому необходимо сравнить важность в сохраненном экземпляре и сейчас
	//  и в случае изменения важности заполнить регистр сведений СостоянияНовостей - включить галочку ОповещениеВключено.
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
		ДополнительныеСвойства.Вставить("ВажностьДоЗаписи", 0);
	Иначе
		ДополнительныеСвойства.Вставить("ЭтоНовый", Ложь);
		ДополнительныеСвойства.Вставить("ВажностьДоЗаписи", Ссылка.Важность);
	КонецЕсли;

	// Если это специальная новость, то дополнительно обработать текст новости.
	Если СокрЛП(ВРег(УИННовости)) = ВРег("7be471d8-3a5d-4a2b-bf67-ca8d632f34d8") Тогда
		// Отсутствует логин / пароль для ленты новостей, которая требует авторизацию.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("8cb9d0fa-dd13-49d7-a023-b207d2cbc8c4") Тогда
		// Неправильный логин / пароль для ленты новостей, которая требует авторизацию.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("bf94d306-8e11-41c2-a7cb-ebc92e8acb3b") Тогда
		// Отсутствует подписка на ИТС, которая требуется для чтения новостей из этой ленты новостей.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("15796c0d-ed48-4a48-90f0-87aa03a158c6") Тогда
		// Закончилась подписка на ИТС, которая требуется для чтения новостей из этой ленты новостей.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("a170042d-a073-456a-91b5-881796995a27") Тогда
		// Конфигурация не находится в списке купленных.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("1cf730e5-241b-4e14-96ce-e74be508abf3") Тогда
		// Защита от брутфорса, при частом обращении за новостями с разными паролями.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("41dbfdc8-665b-4944-b771-608809627916") Тогда
		// Неправильный формат URL для получения новостей.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("1db8ce78-10e1-4556-b891-44b549fe22d7") Тогда
		// Попытка чтения новостей из канала, который не привязан к выбранной конфигурации.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("505748bb-758a-47a5-9566-e4894f85b382") Тогда
		// Попытка чтения новостей из неправильного (несуществующего) канала.
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("e91fabe3-adfd-4fdb-b37d-4799faee32ae") Тогда
		// Попытка чтения новостей в неправильном формате (разрешены только rss, atom, atom1c).
	ИначеЕсли (СокрЛП(ВРег(УИННовости)) = ВРег("313f4928-a71c-4cef-96ee-a4b6106c1275"))
			ИЛИ (СокрЛП(ВРег(УИННовости)) = ВРег("Ошибка")) Тогда
		// Любая другая системная ошибка.
		// Показывать ее в списке новостей не нужно, но стОит записать информацию в журнал регистрации.
		СкрыватьВОбщемСпискеНовостей = Истина;
		ТекстСообщения = НСтр("ru='Перед записью новости про системную ошибку у нее было установлено свойство СкрыватьВОбщемСпискеНовостей, чтобы она не отображалась пользователю.
			|Данные новости:
			|УИН: %УИННовости%
			|Текст новости: %ТекстНовости%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УИННовости%", УИННовости);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТекстНовости%", ТекстНовости);
		// Запись в журнал регистрации
		ИнтернетПоддержкаПользователей.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Изменение данных'"), // ИмяСобытия
			НСтр("ru='Новости. Изменение данных. Новость. Перед записью'"), // ИдентификаторШага
			УровеньЖурналаРегистрации.Предупреждение, // УровеньЖурналаРегистрации.*
			, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейПовтИсп.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("8f9c7dca-3641-4ce1-88cb-5ea1ad021dfd") Тогда
		// Специальная отладочная новость (в url передали параметр debug).
		// Основная цель параметра debug - понять, почему не приходят новости или приходят не в том объеме.
		// Сервер может выдать информацию об общем количестве новостей, наличии подписки ИТС и т.п.,
		//  но некоторые параметры (например, настроенные на клиентском компьютере фильтры) также могут влиять на показ новостей.
		// Поэтому в этой новости также имеет смысл вывести информацию о настроенных фильтрах и т.п.
		// Фильтры и другие настройки могут меняться регулярно, поэтому в текст новости эта информация будет
		//  выведена не сейчас, а перед показом новости. Сейчас мы просто добавим специальный тег,
		//  который при показе и будет заменен.
		ТегКлиентскойИнформации = "<a id=""ClientDebugInformation"" />";
		Если СтрНайти(ВРег(ТекстНовости), ТегКлиентскойИнформации) = 0 Тогда // тег не добавлен на стороне сервера
			ТекстНовости = ТекстНовости + Символы.ПС + Символы.ПС
				+ ТегКлиентскойИнформации;
		КонецЕсли;
	ИначеЕсли СокрЛП(ВРег(УИННовости)) = ВРег("6588f3f9-d569-478f-a370-7cd75d833966") Тогда
		// Сервер новостей для этой ленты давно не отвечает - эта новость может быть создана самой конфигурацией,
		//  а может быть отправлена сервером новостного центра (если он "переехал" на другой адрес).
	КонецЕсли;

	// Проверка прав для записи новости.
	// Записывать новость может:
	//  - Администратор системы (АдминистраторСистемы, без ограничений);
	//  - Редактор новостей (РедактированиеНовостей):
	//    - Только в ленту новостей НЕ загруженную с сервера (ЛентаНовостей.ЗагруженоССервера = Ложь);
	//    - Только в локальную ленту новостей (ЛентаНовостей.ЛокальнаяЛентаНовостей = Истина);
	//    - Лента новостей в списке разрешенных для редактирования этому пользователю
	//        (РегистрСведений.РазрешенныеДляРедактированияЛентыНовостей).

	// Если запись новости происходит из обработки загрузки новостей, то все проверки уже пройдены.
	Если (ДополнительныеСвойства.Свойство("ЭтоЗагрузкаНовостей"))
			И (ДополнительныеСвойства.ЭтоЗагрузкаНовостей = Истина) Тогда
		// Все проверки уже пройдены.
	Иначе
		ВыполнениеРазрешено = Истина;
		// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			// Зашли в конфигурацию под пользователем с разделением (с входом в область данных).
			Если (НЕ ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей())
					// Если вошли в область данных (могли зайти под пользователем без разделителей).
					ИЛИ (ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()) Тогда
				ВыполнениеРазрешено = Ложь;
			КонецЕсли;
		КонецЕсли;

		Если ВыполнениеРазрешено = Ложь Тогда
			Отказ = Истина;
			ТекстСообщения = НСтр("ru='В разделенном режиме разрешено редактировать новости только в неразделенном сеансе.'");
			ВызватьИсключение ТекстСообщения;
		Иначе

			ЭтоАдминистраторСистемы = Пользователи.РолиДоступны("АдминистраторСистемы", , Ложь);
			ЭтоРедакторНовостей     = Пользователи.РолиДоступны("РедактированиеНовостей", , Ложь);

			Если ПривилегированныйРежим() Тогда
				// В привилегированном режиме можно записывать новости без ограничений.
			Иначе
				Если ЭтоАдминистраторСистемы = Истина Тогда
					// АдминистраторСистемы может записывать новости без ограничений.
				Иначе
					Если ЭтоРедакторНовостей = Истина Тогда
						// РедакторНовостей может записывать новости с ограничениями.
						Если ЛентаНовостей.ЗагруженоССервера = Истина Тогда
							Отказ = Истина;
							ТекстСообщения = НСтр("ru='Запрещено записывать новость в ленту новостей, загруженную с сервера.'");
							ВызватьИсключение ТекстСообщения;
						ИначеЕсли ЛентаНовостей.ЛокальнаяЛентаНовостей = Ложь Тогда
							Отказ = Истина;
							ТекстСообщения = НСтр("ru='Запрещено записывать новость в ленту новостей, которая не является локальной.'");
							ВызватьИсключение ТекстСообщения;
						Иначе
							Запрос = Новый Запрос;
							Запрос.Текст = "
								|ВЫБРАТЬ ПЕРВЫЕ 1
								|	Рег.ЛентаНовостей КАК ЛентаНовостей
								|ИЗ
								|	РегистрСведений.РазрешенныеДляРедактированияЛентыНовостей КАК Рег
								|ГДЕ
								|	Рег.Пользователь = &ТекущийПользователь
								|	И Рег.ЛентаНовостей = &ЛентаНовостей
								|";
							Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
							Запрос.УстановитьПараметр("ЛентаНовостей", ЛентаНовостей);
							РезультатЗапроса = Запрос.Выполнить();
							Если РезультатЗапроса.Пустой() Тогда
								Отказ = Истина;
								ТекстСообщения = НСтр("ru='У текущего пользователя (%1)
									|нет прав на запись новости в ленту новостей %2.'");
								ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ТекстСообщения,
									Пользователи.АвторизованныйПользователь(),
									ЛентаНовостей);
								ВызватьИсключение ТекстСообщения;
							Иначе
								// Запись новости возможна.
							КонецЕсли;
						КонецЕсли;
					Иначе
						Отказ = Истина;
						ТекстСообщения = НСтр("ru='Нет прав для записи новости.
							|Запись доступна:
							| - для роли АдминистраторСистемы (без ограничений);
							| - для роли РедакторНовостей (с ограничениями).'");
						ВызватьИсключение ТекстСообщения;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ТекущаяДатаДляРасчетов = ТекущаяУниверсальнаяДата();

	// Если увеличили важность новости с "Обычная" до "Важная" или до "Очень важная", то установить признак "ОповещениеВключено".
	Если ДополнительныеСвойства.ЭтоНовый <> Истина Тогда
		Если ( // Изменилась важность новости - новость стала Важная или Очень важная.
					(ДополнительныеСвойства.ВажностьДоЗаписи <> Важность)
					И (ДополнительныеСвойства.ВажностьДоЗаписи = 0)
					И (Важность > 0))
				ИЛИ (// Если новость загружается заново (перепубликация, отзыв новости и т.п.), то сбросить все пользовательские свойства прочтенности новости - прочтенность, оповещение и т.п.
					(ДополнительныеСвойства.Свойство("СброситьПользовательскиеСвойстваПрочтенностиНовости") = Истина)
						И (ДополнительныеСвойства.СброситьПользовательскиеСвойстваПрочтенностиНовости = Истина)) Тогда

			СброситьСостояниеНовости = Истина;
			Если ДополнительныеСвойства.ЭтоНовый <> Истина Тогда
				ОбработкаНовостейПереопределяемый.ПереопределитьСбросСостоянияНовостиПриЗаписи(ЭтотОбъект, СброситьСостояниеНовости);
				СброситьСостояниеНовости = (СброситьСостояниеНовости <> Ложь); // По-умолчанию - сбрасывать состояние новости
			КонецЕсли;

			Если СброситьСостояниеНовости <> Ложь Тогда
				ОбработкаНовостей.СбросСостоянияНовостиДляВсехПользователей(Ссылка);
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;

	// Заполнить регистр сведений "ПривязкаНовостейКМетаданным".
	// Также пересчет этого регистра осуществляется каждые 30 минут.
	НаборЗаписей = РегистрыСведений.ПривязкаНовостейКМетаданным.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор["Новость"].Установить(Ссылка, Истина);

	Для Каждого ТекущаяПривязкаКМетаданным Из ПривязкаКМетаданным Цикл

		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Новость                 = Ссылка;
		НоваяЗапись.Метаданные              = ТекущаяПривязкаКМетаданным.Метаданные;
		НоваяЗапись.Форма                   = ТекущаяПривязкаКМетаданным.Форма;
		НоваяЗапись.Событие                 = ТекущаяПривязкаКМетаданным.Событие;
		НоваяЗапись.Важность                = ТекущаяПривязкаКМетаданным.Важность;
		НоваяЗапись.Актуальность            = Истина;
		НоваяЗапись.ПоказыватьВФормеОбъекта = ТекущаяПривязкаКМетаданным.ПоказыватьВФормеОбъекта;
		НоваяЗапись.ЭтоПостояннаяНовость    = ТекущаяПривязкаКМетаданным.ЭтоПостояннаяНовость;

		Если ((ДатаЗавершения <> '00010101')
				И (ДатаЗавершения <= ТекущаяДатаДляРасчетов)) Тогда
			НоваяЗапись.Важность     = 0;
			НоваяЗапись.Актуальность = Ложь;
		Иначе
			Если ((ТекущаяПривязкаКМетаданным.ДатаСбросаВажности <> '00010101')
					И (ТекущаяПривязкаКМетаданным.ДатаСбросаВажности <= ТекущаяДатаДляРасчетов)) Тогда
				НоваяЗапись.Важность = 0;
			КонецЕсли;
		КонецЕсли;

		Если ((ТекущаяПривязкаКМетаданным.ДатаСбросаПоказаВФормеОбъекта <> '00010101')
				И (ТекущаяПривязкаКМетаданным.ДатаСбросаПоказаВФормеОбъекта <= ТекущаяДатаДляРасчетов)) Тогда
			НоваяЗапись.ПоказыватьВФормеОбъекта = Ложь;
		КонецЕсли;

		Если ((ТекущаяПривязкаКМетаданным.ДатаСбросаПостояннойНовости <> '00010101')
				И (ТекущаяПривязкаКМетаданным.ДатаСбросаПостояннойНовости <= ТекущаяДатаДляРасчетов)) Тогда
			НоваяЗапись.ЭтоПостояннаяНовость = Ложь;
		КонецЕсли;

	КонецЦикла;

	НаборЗаписей.Записать(Истина);

КонецПроцедуры

#КонецОбласти

#КонецЕсли