#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает номер субконто из настроек плана счетов. В случае, если вид субконто не будет найден - будет возвращен 0.
//	Параметры:
//		Счет - ПланСчетовСсылка.Хозрасчетный - счет, для которого нужно определить номер субконто.
//		ВидСубконто - ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные - вид субконто, номер которого необходимо определить.
//	Возвращаемое значение:
//		Число - номер субконто в счете, если соответствующий вид субконто не найден - 0.
//
Функция НомерСубконто(Счет, ВидСубконто) Экспорт
	
	Результат = 0;
	
	СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для НомерСубконто = 1 По СвойстваСчета.КоличествоСубконто Цикл
		
		Если СвойстваСчета["ВидСубконто" + НомерСубконто] = ВидСубконто Тогда
			Результат = НомерСубконто;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
