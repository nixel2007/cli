
Перем ОписаниеОшибкиКласса;

Функция ВСтроку(Значение) Экспорт
	
	Возврат Строка(Значение);
	
КонецФункции

Функция УстановитьЗначение(Знач ВходящееЗначение, Значение) Экспорт

	Если ТипЗнч(ВходящееЗначение) = Тип("Булево") Тогда
		Возврат ВходящееЗначение;
	КонецЕсли;

	Попытка
		Значение = Булево(ВходящееЗначение);
	Исключение
		ОписаниеОшибкиКласса = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Значение;

КонецФункции 

Функция Ошибка(ЕстьОшибка = Ложь) Экспорт
	
	Если НЕ ПустаяСтрока(ОписаниеОшибкиКласса) Тогда
		ЕстьОшибка = Истина;
	КонецЕсли;

	Возврат ОписаниеОшибкиКласса;
	
КонецФункции

ОписаниеОшибкиКласса = "";