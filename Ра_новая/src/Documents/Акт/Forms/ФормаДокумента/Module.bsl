
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.Грузоотправитель) Тогда 
		Если Объект.Организация.ИНН = "6679121870" Тогда 
			Объект.Грузоотправитель = "ООО ""Трионикс"" 620076, г. Екатеринбург, переулок Короткий, д 9 кв.123";
		Иначе 	
			Объект.Грузоотправитель = "ООО ""Баннерные ткани"" 620026, Свердловская обл, Екатеринбург г, Декабристов ул, д. 14, кв. 94";
		КонецЕсли;
		Модифицированность = Истина;	
	КонецЕсли;	
	
	Если Параметры.Ключ.Пустая() и 
		ЗначениеЗаполнено(Объект.Основание) Тогда  //доб. 17.01.20
		//Найдем акт	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Акт.Ссылка
		|ИЗ
		|	Документ.Акт КАК Акт
		|ГДЕ
		|	Акт.Основание = &Основание";
		
		Запрос.УстановитьПараметр("Основание", Объект.Основание);
		
		Если Не Запрос.Выполнить().Пустой() Тогда 
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Акт уже введен!";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		
		Если Объект.Организация.ИНН = "6679121870" Тогда 
			Объект.Грузоотправитель = "ООО ""Трионикс"" 620076, г. Екатеринбург, переулок Короткий, д 9 кв.123";
		Иначе 	
			Объект.Грузоотправитель = "ООО ""Баннерные ткани"" 620026, Свердловская обл, Екатеринбург г, Декабристов ул, д. 14, кв. 94";
		КонецЕсли;		
	КонецЕсли;
	
	Если  Не Объект.СуммаДокумента = Объект.Товары.Итог("Всего") Тогда 
		Объект.СуммаДокумента = Объект.Товары.Итог("Всего");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Статус) Тогда
		Если Объект.Статус = Перечисления.Статусы.Закрыт И Не РольДоступна("УУ") Тогда 
			ЭтаФорма.ТолькоПросмотр = Истина;
		иначе
			//Если Объект.Проведен И Не РольДоступна("УУ") И Не РольДоступна("Бухгалтер") Тогда 
			//	ЭтаФорма.ТолькоПросмотр = Истина;
			//Иначе 
			//	ЭтаФорма.ТолькоПросмотр = Ложь;
			//КонецЕсли;
		КонецЕсли;	
	иначе	
		Объект.Статус 		= Перечисления.Статусы.Вработе;
		Модифицированность 	= Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВсегоНДС = Объект.Товары.Итог("СуммаНДС");
КонецПроцедуры

&НаКлиенте
Процедура Расчитать()
	ТекущиеДанные =  Элементы.Товары.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.Цена*ТекущиеДанные.Количество;
	Если Строка(ТекущиеДанные.НДС) = "Без НДС" Тогда
		ТекущиеДанные.СуммаНДС = 0;
	иначеЕсли Строка(ТекущиеДанные.НДС) = "18%" Тогда
		Если Объект.НДС_В_томЧисле Тогда
			ТекущиеДанные.СуммаНДС = ТекущиеДанные.Сумма/118*18;
		иначе	
			ТекущиеДанные.СуммаНДС = ТекущиеДанные.Сумма*0.18;
		КонецЕсли;
	иначеЕсли Строка(ТекущиеДанные.НДС) = "20%" Тогда
		Если Объект.НДС_В_томЧисле Тогда
			ТекущиеДанные.СуммаНДС = ТекущиеДанные.Сумма/120*20;
		иначе	
			ТекущиеДанные.СуммаНДС = ТекущиеДанные.Сумма*0.2;
		КонецЕсли;
	КонецЕсли;
	ТекущиеДанные.Всего	= ТекущиеДанные.Сумма+ТекущиеДанные.СуммаНДС;
	Объект.СуммаДокумента 	= Объект.Товары.Итог("Всего");
КонецПроцедуры	

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	Расчитать();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	Расчитать();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНДСПриИзменении(Элемент)
	Расчитать();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВсегоПриИзменении(Элемент)
	ТекущиеДанные =  Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные.СуммаНДС>0 Тогда 
		Если НЕ ТекущиеДанные.Всего = ТекущиеДанные.Сумма+ТекущиеДанные.СуммаНДС Тогда 
			Сообщить("В строке:"+ТекущиеДанные.НомерСтроки+" (Сумма+Сумма НДС) не равна (Всего)"
			+Символы.ПС+"Для документа с НДС, не должно быть так");
			ТекущиеДанные.Всего = ТекущиеДанные.Сумма+ТекущиеДанные.СуммаНДС;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры
