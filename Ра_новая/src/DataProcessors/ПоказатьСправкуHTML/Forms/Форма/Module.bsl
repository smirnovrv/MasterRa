// @strict-types


&НаКлиенте
Процедура Команда1(Команда)        
	ПолучитьМакетНаСервере();
	//Макет = ПолучитьМакетНаСервере();
	//тМакет =  Макет.ПолучитьТекст();
	//Элементы.ПредставлениеHTML.УстановитьТекст(тМакет);
КонецПроцедуры 

&НаСервере
Процедура  ПолучитьМакетНаСервере()
	тМакет = Обработки.ПоказатьСправкуHTML.ПолучитьМакет("ОписаниеВерсииПрограммы").ПолучитьТекст();
	ПредставлениеHTML = тМакет;
КонецПроцедуры

 &НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	тМакет = Обработки.ПоказатьСправкуHTML.ПолучитьМакет("ОписаниеВерсииПрограммы").ПолучитьТекст();
	ПредставлениеHTML = тМакет;
КонецПроцедуры

