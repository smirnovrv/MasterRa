// @strict-types


&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктОбОказанииПроизводственныхУслуг_Акт";
	Печать(ТабДок, ПараметрКоманды);
	ТабДок.ОтображатьСетку 		= Ложь;
	ТабДок.ОтображатьЗаголовки 	= Ложь;
	ТабДок.Показать("");

КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	Документы.Акт.ПечатьАкта(ТабДок, ПараметрКоманды);
КонецПроцедуры
