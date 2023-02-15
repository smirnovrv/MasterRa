
&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	ВывестиНомерСтатьи();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиНомерСтатьи()
	Если Объект.СтатьяРасходов.КодМинор=0 Тогда                     
		Объект.НомерСтатьиРасхода = Строка(Объект.СтатьяРасходов.Код);
	иначе	
		Объект.НомерСтатьиРасхода = Строка(Объект.СтатьяРасходов.Код)+"."+Строка(Объект.СтатьяРасходов.КодМинор);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыЗаявкаПриИзменении(Элемент)
	ТекущиеДанные =  Элементы.Заказы.ТекущиеДанные;
	ТекущиеДанные.КодЗаказа = ТекущиеДанные.Заявка.Номер; 
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыСуммаПриИзменении(Элемент)
	РассчитатьСумму();
КонецПроцедуры

Процедура РассчитатьСумму()
	Объект.СуммаДокумента = Объект.Заказы.Итог("Сумма");	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Для Каждого стрЗаказы из Объект.Заказы Цикл
			Если стрЗаказы.НомерСтроки=Объект.Заказы.Количество() Тогда 
				Объект.КодыЗаказов	= Объект.КодыЗаказов+" "+стрЗаказы.Заявка.Номер;
			ИначеЕсли стрЗаказы.НомерСтроки=1 Тогда   	
				Объект.КодыЗаказов	= стрЗаказы.Заявка.Номер+",";
			иначе
				Объект.КодыЗаказов	= Объект.КодыЗаказов+" "+стрЗаказы.Заявка.Номер+",";
			КонецЕсли;
	КонецЦикла;
КонецПроцедуры
