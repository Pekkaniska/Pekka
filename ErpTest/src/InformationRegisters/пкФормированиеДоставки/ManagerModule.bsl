
////////////////////////////////////////////////////////////////////////////////////////

//Добавить тЗаданиеНаПеревозку в доставку по параметрам, указанным в ПараметрыДоставки
// ПараметрыДоставки:
//	- ДатаДоставки
//	- Подразделение
//	- Транспорт
//	- Водитель
//	- Перевозчик
//	- НомерХодки
//  , ТочкаМаршрутаОпределяется по данным параметрам доставки(или в уже имеющаяся, или новая точка)
Функция ДобавитьЗаданиеНаПеревозкуВДоставку(тЗаданиеНаПеревозку, ПараметрыДоставки, ИскатьДляСвязанных = Истина, ТочкаМаршрута = 0) Экспорт
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(тЗаданиеНаПеревозку) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыДоставки.ДатаДоставки) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыДоставки.Подразделение) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыДоставки.Транспорт) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат Отказ;
	КонецЕсли;
	
	ЗапросМаршрут = Новый Запрос;
	ЗапросМаршрут.Текст =
	"ВЫБРАТЬ
	|	пкФормированиеДоставки.ЗаданиеНаПеревозку,
	|	пкФормированиеДоставки.ТочкаМаршрута КАК ТочкаМаршрута,
	|	пкФормированиеДоставки.Водитель,
	|	пкФормированиеДоставки.Перевозчик
	|ИЗ
	|	РегистрСведений.пкФормированиеДоставки КАК пкФормированиеДоставки
	|ГДЕ
	|	пкФормированиеДоставки.ДатаДоставки = &ДатаДоставки
	|	И пкФормированиеДоставки.Подразделение = &Подразделение
	|	И пкФормированиеДоставки.Транспорт = &Транспорт
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТочкаМаршрута";
	ЗапросМаршрут.УстановитьПараметр("ДатаДоставки", ПараметрыДоставки.ДатаДоставки);
	ЗапросМаршрут.УстановитьПараметр("Подразделение", ПараметрыДоставки.Подразделение);
	ЗапросМаршрут.УстановитьПараметр("Транспорт", ПараметрыДоставки.Транспорт);
	
	Маршрут = ЗапросМаршрут.Выполнить().Выгрузить();
	
	//1. Проверить возможность добавления по Способу доставки
	//ДоступныйСпособДоставки = Истина;
	//Для Каждого текТочка Из Маршрут Цикл
	//	ДоступныйСпособДоставки = (ДоступныйСпособДоставки И текТочка.ЗаданиеНаПеревозку.СпособДоставки = тЗаданиеНаПеревозку.СпособДоставки);
	//КонецЦикла;
	//
	//Если Не ДоступныйСпособДоставки Тогда
	//	
	//	тСообщение = Новый СообщениеПользователю;
	//	тСообщение.Текст = НСтр("ru='Невозможно добавить задание с другим способом доставки в уже существующий маршрут.'");
	//	тСообщение.Сообщить();
	//	
	//	Отказ = Истина;
	//	Возврат Отказ;
	//	
	//КонецЕсли;
	
	//2. Для переката-погрузки добавляем выезд
	Если ИскатьДляСвязанных Тогда
		Если тЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат Тогда
			Если ЗначениеЗаполнено(тЗаданиеНаПеревозку.ЗаданиеНаПеревозку) Тогда //Получатель - помещаем родителя в Маршрут
				Отказ = ДобавитьЗаданиеНаПеревозкуВДоставку(тЗаданиеНаПеревозку.ЗаданиеНаПеревозку, ПараметрыДоставки, Истина);
				Возврат Отказ;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	//3. Нужно определить точку маршрута по транспорту в этот день и адресу в задании на перевозку
	ПоследняяТочка	= 0;
	
	Водитель		= ПараметрыДоставки.Водитель;
	Перевозчик		= ПараметрыДоставки.Перевозчик;
	
	Для Каждого текТочка Из Маршрут Цикл
		
		Водитель	= текТочка.Водитель;
		Перевозчик	= текТочка.Перевозчик;
		
		Если Лев(тЗаданиеНаПеревозку.АдресДоставки, 1000) = Лев(текТочка.ЗаданиеНаПеревозку.АдресДоставки, 1000) Тогда
			Если ТочкаМаршрута <= текТочка.ТочкаМаршрута Тогда
				ТочкаМаршрута = текТочка.ТочкаМаршрута;
			Иначе
				
//Раррус Владимир Подрещов 09.10.2017 5963
//Закомментируем проверку, в принципе может быть могоступенчатый перекат туда-обратно-туда...
//				тСообщение = Новый СообщениеПользователю;
//				тСообщение.Текст = НСтр("ru='Невозможно добавить Перекат: адрес разгрузки раньше адреса погрузки!.'");
//				тСообщение.Сообщить();
//				
//				Отказ = Истина;
//				Возврат Отказ;
//Раррус Владимир Подрещов Конец
				
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
		ПоследняяТочка = текТочка.ТочкаМаршрута;
		
	КонецЦикла;
	
	//ОПРЕДЕЛЯЕМ ТОЧКУ
	ТочкаМаршрута = Макс(ТочкаМаршрута, ПоследняяТочка + 1);
	
	//4. Проверим Акт на предмет свободности
	тАкт = АктПоЗаданию(тЗаданиеНаПеревозку);
	Если ЗначениеЗаполнено(тАкт) И ЗначениеЗаполнено(тАкт.Доставка) Тогда
		
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Выбранное задание уже в не свободном Акте по доставке:'") + тАкт.Доставка;
		тСообщение.Сообщить();
		
		Отказ = Истина;
		Возврат Отказ;
		
	КонецЕсли;

	//5. Обработаем связанные: 
	//		- Для переката надо найти связанные вторые стороны и сдвинуть с ними
	//		- Соседние в свободном Акте сдвинуть с ними
	Если ИскатьДляСвязанных Тогда
		Если тЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат Тогда
			Если НЕ ЗначениеЗаполнено(тЗаданиеНаПеревозку.ЗаданиеНаПеревозку) Тогда //Отправитель
				
				//Ищем все подчиненные и тоже помещаем в маршрут
				ЗапросКонецПереката = Новый Запрос;
				ЗапросКонецПереката.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	пкЗаданиеНаПеревозку.Ссылка КАК ЗаданиеНаПеревозку
				|ИЗ
				|	Документ.пкЗаданиеНаПеревозку КАК пкЗаданиеНаПеревозку
				|ГДЕ
				|	НЕ пкЗаданиеНаПеревозку.ПометкаУдаления
				|	И пкЗаданиеНаПеревозку.Проведен
				|	И пкЗаданиеНаПеревозку.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку";
				ЗапросКонецПереката.УстановитьПараметр("ЗаданиеНаПеревозку", тЗаданиеНаПеревозку);
				ТекущиеЗаданияНаПеревозку = ЗапросКонецПереката.Выполнить().Выгрузить();
				Для Каждого текСтрока Из ТекущиеЗаданияНаПеревозку Цикл
					Отказ = Отказ ИЛИ ДобавитьЗаданиеНаПеревозкуВДоставку(текСтрока.ЗаданиеНаПеревозку, ПараметрыДоставки, Ложь, ТочкаМаршрута + 1);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(тАкт) Тогда
			Для Каждого текСтрока Из тАкт.ЗаданияНаПеревозку Цикл
				Если текСтрока.ЗаданиеНаПеревозку = тЗаданиеНаПеревозку Тогда
					Продолжить;
				КонецЕсли;
				Отказ = Отказ ИЛИ ДобавитьЗаданиеНаПеревозкуВДоставку(текСтрока.ЗаданиеНаПеревозку, ПараметрыДоставки, Ложь, ТочкаМаршрута);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	//6. Все в порядке можно записывать
	Если Не Отказ Тогда
		//...дозаполним водителя/перевозчика если вдруг они не указаны
		Если (Не ЗначениеЗаполнено(Водитель))
			И(Не ЗначениеЗаполнено(Перевозчик))
		Тогда
		
			ЗапросВодитель = Новый Запрос;
			ЗапросВодитель.Текст = 
			"ВЫБРАТЬ
			|	уатЭкипажТС.Сотрудник
			|ИЗ
			|	РегистрСведений.уатЭкипажТС КАК уатЭкипажТС
			|ГДЕ
			|	уатЭкипажТС.ТС = &ТС
			|	И уатЭкипажТС.ЧленЭкипажа = &ЧленЭкипажа";
			ЗапросВодитель.УстановитьПараметр("ТС", ПараметрыДоставки.Транспорт);
			ЗапросВодитель.УстановитьПараметр("ЧленЭкипажа", Перечисления.уатЧленыЭкипажа.ОсновнойВодитель);
			РезЗапроса = ЗапросВодитель.Выполнить().Выбрать();
			Если РезЗапроса.Следующий() Тогда
				Водитель = РезЗапроса.Сотрудник.ФизическоеЛицо;
			КонецЕсли;
			
		КонецЕсли;
		
		ПараметрыДоставки.Водитель					= Водитель;
		ПараметрыДоставки.Перевозчик				= Перевозчик;
		ПараметрыДоставки.Вставить("ТочкаМаршрута", ТочкаМаршрута);
		ЗаписатьПараметрыДляЗадания(тЗаданиеНаПеревозку, ПараметрыДоставки);
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

//Удаляем тЗаданиеНаПеревозку из буфера формирования доставки:
// - когда сформировали документ пкДоставка
// - пользователь удалил доставку интерактивно в обработке Управление логистикой
Процедура ИсключитьЗаданиеИзДоставки(тЗаданиеНаПеревозку, ИскатьДляСвязанных = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(тЗаданиеНаПеревозку) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.пкФормированиеДоставки.СоздатьНаборЗаписей();
	НаборЗаписей.Записывать = Истина;
	
	НаборЗаписей.Отбор.ЗаданиеНаПеревозку.Установить(тЗаданиеНаПеревозку, Истина);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	Попытка
		НаборЗаписей.Записать(Истина);
	Исключение
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = ОписаниеОшибки();
		тСообщение.Сообщить();
	КонецПопытки;
	
	Если ИскатьДляСвязанных Тогда
		Если тЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат Тогда
			Если НЕ ЗначениеЗаполнено(тЗаданиеНаПеревозку.ЗаданиеНаПеревозку) Тогда //Отправитель
				
				//Ищем все подчиненные и тоже помещаем в маршрут
				ЗапросКонецПереката = Новый Запрос;
				ЗапросКонецПереката.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	пкЗаданиеНаПеревозку.Ссылка КАК ЗаданиеНаПеревозку
				|ИЗ
				|	Документ.пкЗаданиеНаПеревозку КАК пкЗаданиеНаПеревозку
				|ГДЕ
				|	НЕ пкЗаданиеНаПеревозку.ПометкаУдаления
				|	И пкЗаданиеНаПеревозку.Проведен
				|	И пкЗаданиеНаПеревозку.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку";
				ЗапросКонецПереката.УстановитьПараметр("ЗаданиеНаПеревозку", тЗаданиеНаПеревозку);
				ТекущиеЗаданияНаПеревозку = ЗапросКонецПереката.Выполнить().Выгрузить();
				Для Каждого текСтрока Из ТекущиеЗаданияНаПеревозку Цикл
					ИсключитьЗаданиеИзДоставки(текСтрока.ЗаданиеНаПеревозку, Ложь);
				КонецЦикла;
				
			Иначе //Получатель - помещаем родителя в Маршрут
				ИсключитьЗаданиеИзДоставки(тЗаданиеНаПеревозку.ЗаданиеНаПеревозку, Ложь);
			КонецЕсли;
		КонецЕсли;
		
		тАкт = АктПоЗаданию(тЗаданиеНаПеревозку);
		Если ЗначениеЗаполнено(тАкт) Тогда
			Для Каждого текСтрока Из тАкт.ЗаданияНаПеревозку Цикл
				Если текСтрока.ЗаданиеНаПеревозку = тЗаданиеНаПеревозку Тогда
					Продолжить;
				КонецЕсли;
				ИсключитьЗаданиеИзДоставки(текСтрока.ЗаданиеНаПеревозку, Ложь);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//Записать параметры доставки для тЗаданиеНаПеревозку:
// ПараметрыДоставки:
//	- ДатаДоставки
//	- Подразделение
//	- Транспорт
//	- Водитель
//	- Перевозчик
//  - ТочкаМаршрута
Процедура ЗаписатьПараметрыДляЗадания(тЗаданиеНаПеревозку, ПараметрыДоставки) Экспорт
	
	Если Не ЗначениеЗаполнено(тЗаданиеНаПеревозку) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыДоставки.ДатаДоставки) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыДоставки.Подразделение) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыДоставки.Транспорт) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.пкФормированиеДоставки.СоздатьНаборЗаписей();
	НаборЗаписей.Записывать = Истина;
	
	НаборЗаписей.Отбор.ЗаданиеНаПеревозку.Установить(тЗаданиеНаПеревозку, Истина);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	НоваяЗаись = НаборЗаписей.Добавить();
	НоваяЗаись.ЗаданиеНаПеревозку	= тЗаданиеНаПеревозку;
	НоваяЗаись.ДатаДоставки			= ПараметрыДоставки.ДатаДоставки;
	НоваяЗаись.Подразделение		= ПараметрыДоставки.Подразделение;
	НоваяЗаись.Транспорт			= ПараметрыДоставки.Транспорт;
	НоваяЗаись.Водитель				= ПараметрыДоставки.Водитель;
	НоваяЗаись.Перевозчик			= ПараметрыДоставки.Перевозчик;
	НоваяЗаись.НомерХодки			= ПараметрыДоставки.НомерХодки;
	НоваяЗаись.ТочкаМаршрута		= ПараметрыДоставки.ТочкаМаршрута;
	
	Попытка
		НаборЗаписей.Записать(Истина);
	Исключение
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = ОписаниеОшибки();
		тСообщение.Сообщить();
	КонецПопытки;
	
КонецПроцедуры

Функция АктПоЗаданию(тЗаданиеНаПеревозку)
	
	Если Не ЗначениеЗаполнено(тЗаданиеНаПеревозку) Тогда
		Возврат Документы.пкАктПриемкиВозврата.ПустаяСсылка();
	КонецЕсли;
	
	ЗапросАкты = Новый Запрос;
	ЗапросАкты.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	пкАктПриемкиВозвратаЗаданияНаПеревозку.Ссылка
	|ИЗ
	|	Документ.пкАктПриемкиВозврата.ЗаданияНаПеревозку КАК пкАктПриемкиВозвратаЗаданияНаПеревозку
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.пкАктПриемкиВозврата КАК пкАктПриемкиВозврата
	|		ПО пкАктПриемкиВозвратаЗаданияНаПеревозку.Ссылка = пкАктПриемкиВозврата.Ссылка
	|ГДЕ
	|	пкАктПриемкиВозвратаЗаданияНаПеревозку.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку";
	ЗапросАкты.УстановитьПараметр("ЗаданиеНаПеревозку", тЗаданиеНаПеревозку);
	РезЗапроса = ЗапросАкты.Выполнить().Выбрать();
	
	Если РезЗапроса.Следующий() Тогда
		Возврат РезЗапроса.Ссылка;
	Иначе
		Возврат Документы.пкАктПриемкиВозврата.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции
