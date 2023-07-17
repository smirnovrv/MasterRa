&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если РольДоступна("МастерМерч") Тогда 	
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ПолучательТовара");
		ЭлементОтбора.ПравоеЗначение 	= ПараметрыСеанса.ТекущийПользователь.Организация;
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
	КонецЕсли;
КонецПроцедуры
