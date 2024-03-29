// @strict-types



Процедура РассчитатьСумму()
	Объект.СуммаДокумента = Объект.Заказы.Итог("Сумма");	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаказыСуммаПриИзменении(Элемент)
	РассчитатьСумму();
КонецПроцедуры

&НаКлиенте
Процедура ОбоснованиеПлатежаПриИзменении(Элемент)
	Если ТипЗнч(Объект.ОбоснованиеПлатежа) = Тип("ДокументСсылка.Счет") Тогда 		
		ЗаполнитьПКО_ПоСчетуНаСервере(Объект.ОбоснованиеПлатежа);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПКО_ПоСчетуНаСервере(Счет)	
	Если Объект.Заказы.Количество()>0 Тогда 
		Объект.Заказы.Очистить();
	КонецЕсли;
	Для Каждого стрТовары Из Счет.Товары Цикл
		новСтрока = Объект.Заказы.Добавить();
		новСтрока.Заявка 	= стрТовары.КодЗаказа;
		новСтрока.КодЗаказа = стрТовары.КодЗаказа.Номер;
		//{+} 07.02.22
		//новСтрока.Сумма 	= стрТовары.Сумма;
		новСтрока.Сумма 	= стрТовары.Всего;
		//{-}
	КонецЦикла;	
	РассчитатьСумму();
КонецПроцедуры	

&НаСервере
Функция ПолучитьКодМинор(СтатьяДоходов)
	Возврат СтатьяДоходов.КодМинор;
КонецФункции

&НаСервере
Функция ПолучитьКод(СтатьяДоходов)
	Возврат СтатьяДоходов.Код;
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Для Каждого стрЗаказы из Объект.Заказы Цикл
		Если ЗначениеЗаполнено(стрЗаказы.КодЗаказа) Тогда 
			 тКодЗаказа = стрЗаказы.КодЗаказа;
		 иначе
			тКодЗаказа = ПолучитьНомерЗаказ(стрЗаказы.Заявка); 
		КонецЕсли;	
		Если стрЗаказы.НомерСтроки=Объект.Заказы.Количество() Тогда 
			Объект.КодыЗаказов	= Объект.КодыЗаказов+" "+тКодЗаказа;
		ИначеЕсли стрЗаказы.НомерСтроки=1 Тогда   	
			Объект.КодыЗаказов	= тКодЗаказа+",";
		иначе
			Объект.КодыЗаказов	= Объект.КодыЗаказов+" "+тКодЗаказа+",";
		КонецЕсли;
	КонецЦикла
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыЗаявкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Заказы.ТекущиеДанные;      
	ТекущиеДанные.кодЗаказа = ПолучитьНомерЗаказ(ТекущиеДанные.Заявка);
КонецПроцедуры
	
Функция ПолучитьНомерЗаказ(Заявка)
	  Возврат  Заявка.Номер;
  КонецФункции	

&НаКлиенте
Процедура ЗаказыСтатьяДоходаПриИзменении(Элемент)
	текСтрока = ЭтаФорма.Элементы.Заказы.ТекущиеДанные;
	КодМинор = ПолучитьКодМинор(текСтрока.СтатьяДохода);
	Код      = ПолучитьКод(текСтрока.СтатьяДохода);
	Если КодМинор=0 Тогда                     
		текСтрока.НомерСтатьиПрихода = Строка(Код);
	иначе	
		текСтрока.НомерСтатьиПрихода = Строка(Код)+"."+Строка(КодМинор);
	КонецЕсли;	  
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Статус) Тогда
		Если Объект.Статус = Перечисления.Статусы.Закрыт И Не РольДоступна("УУ") Тогда 
			ЭтаФорма.ТолькоПросмотр = Истина;
		иначе
			ЭтаФорма.ТолькоПросмотр = Ложь;
		КонецЕсли;	
	иначе	
		Объект.Статус 		= Перечисления.Статусы.Вработе;
		Модифицированность 	= Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыПослеУдаления(Элемент)
	РассчитатьСумму();
КонецПроцедуры
