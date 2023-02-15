
Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)
	УстановленныеПараметры = Новый Структура;
	Если ТребуемыеПараметры = Неопределено Тогда
		УстановитьЗначениеПараметраСеанса("ТекущийПользователь",УстановленныеПараметры);
	иначе	
		Для Каждого ИмяПараметра ИЗ ТребуемыеПараметры Цикл
			УстановитьЗначениеПараметраСеанса(ИмяПараметра, УстановленныеПараметры);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьЗначениеПараметраСеанса(ИмяПараметра, УстановленныеПараметры)

	Если ИмяПараметра = "ТекущийПользователь" Тогда
		ОбщегоНазначения.ОпределитьТекущегоПользователя("ТекущийПользователь", УстановленныеПараметры);		
	КонецЕсли;
	
КонецПроцедуры