QT += core
QT -= gui

CONFIG += c++11

TARGET = Server
CONFIG += console
CONFIG -= app_bundle

QMAKE_CXXFLAGS += -m32 -static -Wl,-z,defs -Wall -Wl,-m32
TEMPLATE = app

LIBS += -L..\..\Server -lServer

SOURCES += main.cpp

