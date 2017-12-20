
#Использовать logos
перем Лог;

Перем Завершено Экспорт;
Перем МассивСоединений Экспорт;

Процедура ПриСозданииОбъекта()
	
	МассивСоединений = Новый Массив;
	Завершено = Ложь;

КонецПроцедуры

Функция Т(Парсер, СледующееСостояние) Экспорт
	
	МассивСоединений.Добавить(НовоеСоединениеСовпадений(Парсер, СледующееСостояние));
	Возврат СледующееСостояние;

КонецФункции

Функция НовоеСоединениеСовпадений(Парсер, СледующееСостояние)

	Возврат Новый Структура("Парсер, СледующееСостояние", Парсер, СледующееСостояние);
	
КонецФункции

Процедура Подготовить() Экспорт
	
	ПосетилиСостояниеСортировки = Новый Соответствие;
	ПосетилиСостояниеУпрощения = Новый Соответствие;
	fsm = новый ВыборСовпадений();
	fsm.УпроститьСоединения(ЭтотОбъект, ЭтотОбъект, ПосетилиСостояниеУпрощения); // тут косяк
	fsm.СортировкаСоединений(ЭтотОбъект, ПосетилиСостояниеСортировки);

КонецПроцедуры

Функция Прочитать(ВходящиеАргументы) Экспорт
	
	Контекст = Новый КонтекстПарсеров;
	
	Успех = ПрименитьКонтекст(ВходящиеАргументы, Контекст);

	Если Не Успех Тогда
		Возврат Ложь;
	КонецЕсли;

	fsm = новый ВыборСовпадений();
	
	fsm.ЗаполнитьЗначения(Контекст.Опции);

	fsm.ЗаполнитьЗначения(Контекст.Аргументы);
	
	Лог.Отладка("Проверка контекста: 
	| количество опций: %1", Контекст.Опции.Количество());
	
	Возврат истина;

КонецФункции

Функция ПрименитьКонтекст(Знач ВходящиеАргументы, Контекст) Экспорт
	
	Лог.Отладка("Применяю контекст: 
	| количество соединений %1
	| количество входящих аргументов %2
	| Завершено: %3", МассивСоединений.Количество(), ВходящиеАргументы.Количество(), Завершено);
	
	Если Завершено 
		И ВходящиеАргументы.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;

	Если ВходящиеАргументы.Количество() > 0 Тогда
		
		ПервыйАргумент = ВходящиеАргументы[0];
		Если Не Контекст.СбросОпций
			И СокрЛП(ПервыйАргумент) = "--" Тогда
			Контекст.СбросОпций = Истина;
			ВходящиеАргументы.Удалить(0);
		КонецЕсли;

	КонецЕсли;

	МассивСовпадений = Новый Массив;

	Лог.Отладка("Перебираю возможные пути: %1", МассивСоединений.Количество() );
	Номер = 1;
	Для каждого Соединение Из МассивСоединений Цикл
		Лог.Отладка("Перебираю путь номер: %1", Номер);
		ЧистыйКонтекст = Новый КонтекстПарсеров;
		ЧистыйКонтекст.СбросОпций = Контекст.СбросОпций;

		РезультатПоиска = Соединение.Парсер.Поиск(ВходящиеАргументы, ЧистыйКонтекст);
		
		Лог.Отладка("Нашли опции: %2 %1", РезультатПоиска.РезультатПоиска, Соединение.Парсер.ВСтроку() );
		лог.Отладка("Количество опций в контексте: %1", ЧистыйКонтекст.Опции.Количество());
		лог.Отладка("Количество аргументов после поиска: %1", РезультатПоиска.Аргументы.Количество());
		Если РезультатПоиска.РезультатПоиска Тогда
			Лог.Отладка("Добавляю в массив найденное значение");
			МассивСовпадений.Добавить(НовоеСовпадение(Соединение, РезультатПоиска.Аргументы, ЧистыйКонтекст));
		КонецЕсли;

		Номер = Номер +1;
	КонецЦикла;
	
	Для каждого ЭлементСовпадения Из МассивСовпадений Цикл

		Лог.Отладка("Следующие состояние: %1", ЭлементСовпадения.Соединение.СледующееСостояние);
		Лог.Отладка("Для соединения беру следующие состояние: %1", ЭлементСовпадения.Соединение.СледующееСостояние.МассивСоединений.Количество());
		
		Если ЭлементСовпадения.Соединение.СледующееСостояние.ПрименитьКонтекст(ЭлементСовпадения.Результат, ЭлементСовпадения.Контекст)  Тогда
			
			Лог.Отладка("Соединяю контексты");
			Контекст.ПрисоединитьКонтекст(ЭлементСовпадения.Контекст);
			Возврат Истина;
		КонецЕсли;

	КонецЦикла;

	Возврат Ложь

КонецФункции
	
Процедура СообщитьСоединения() Экспорт

	Лог.Отладка("Завершено: %1", Завершено);
	Лог.Отладка("КоличествоСоединений: %1", МассивСоединений.Количество());
	
	Для каждого Переменная Из МассивСоединений Цикл
		Лог.Отладка("Класс текущего соединения: %1", Переменная.Парсер);
		Лог.Отладка("Следующие состояние завершено: %1",Переменная.СледующееСостояние.Завершено);
		Лог.Отладка("Следующие состояние КоличествоСоединений: %1",Переменная.СледующееСостояние.МассивСоединений.Количество());
		Лог.Отладка("Вывожу сообщения для следующего состояния");
		Переменная.СледующееСостояние.СообщитьСоединения();	
	КонецЦикла;

КонецПроцедуры

Функция СодержитСоединения(Знач СоединениеПроверки) Экспорт

	Для каждого Соединение Из МассивСоединений Цикл
		
		Если Соединение.СледующееСостояние = СоединениеПроверки.СледующееСостояние
			И Соединение.Парсер = СоединениеПроверки.Парсер Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;

	Возврат Ложь
	
КонецФункции

Функция УпроститьСвоиСоединения() Экспорт

	
	Индекс = 0;
	
	Лог.Отладка("Я всего соединений: %1", МассивСоединений.Количество());
	
	Пока Индекс <= МассивСоединений.ВГраница() Цикл
		Лог.Отладка("Я всего соединений внутри: %1", МассивСоединений.Количество());
		
		Соединение = МассивСоединений[Индекс];

		Если ТипЗнч(Соединение.Парсер) = Тип("ЛюбойСимвол") Тогда
			Лог.Отладка("Я Нашел ЛюбойСимвол");
	
			СледующееСостояние = Соединение.СледующееСостояние;
			
			Для каждого СоединениеСледующего Из СледующееСостояние.МассивСоединений Цикл

				Если НЕ СодержитСоединения(СоединениеСледующего) Тогда

					Лог.Отладка("Я добавил сюда подчиненные соединения");
	
					МассивСоединений.Добавить(СоединениеСледующего);
					Лог.Отладка("Добавляю соединение с парсером %1", СоединениеСледующего.Парсер);
	
				КонецЕсли;

			КонецЦикла;

			Лог.Отладка("Упростить завершено %1", Завершено);
			Лог.Отладка("Упростить следующие состояние завершено %1", СледующееСостояние.Завершено);
			
			Если СледующееСостояние.Завершено Тогда
				Завершено = Истина;
				Лог.Отладка("Упростить установлено завершено %1", Завершено);
			КонецЕсли;
			Лог.Отладка("Удалил соединение с индексом %1", Индекс);
			МассивСоединений.Удалить(Индекс);

			Возврат Истина;

		Иначе

			Индекс = Индекс + 1;

		КонецЕсли;
		
	КонецЦикла;

	Возврат Ложь;

КонецФункции

Функция НовоеСовпадение(Соединение, Результат, Контекст)
	Возврат Новый Структура("Соединение, Результат, Контекст", Соединение, Результат, Контекст)
КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.cli_state");
//Лог.УстановитьУровень(УровниЛога.Отладка);