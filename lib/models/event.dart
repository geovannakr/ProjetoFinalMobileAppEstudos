import 'package:flutter/material.dart';

/// Notificador global que guarda os eventos do calendário.
/// Key = Data (normalizada para ano, mês, dia)
/// Value = Lista de eventos (tarefas, provas, etc.)
ValueNotifier<Map<DateTime, List<String>>> eventNotifier = 
    ValueNotifier<Map<DateTime, List<String>>>({});