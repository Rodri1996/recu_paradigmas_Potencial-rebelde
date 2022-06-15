% 1) Modelar la base de conocimiento para incluir estos datos, agregar alguna persona y vivienda más.

% Modelamos a las personas:
persona('912ec803b2ce49e4a541068d495ab570').
persona('2e416649e6ca0a1cbf9a1210cf4ce234').
persona('f55840c38474c1909ce742172a77a013').
persona('42fc1cd45335ad42d603657e5d0f2682').
% Me agrego a mi (Rodrigo):
persona('2e247e2eb505c42b362e80ed4d05b078').

% Modelamos donde trabajan las personas:
trabajaDe('912ec803b2ce49e4a541068d495ab570',ingenieraMecanica).
trabajaDe('2e416649e6ca0a1cbf9a1210cf4ce234',aviacionMilitar).
trabajaDe('f55840c38474c1909ce742172a77a013',inteligenciaMilitar).
trabajaDe('2e247e2eb505c42b362e80ed4d05b078',testingDeSoftware).

% Agregamos los trabajos de indole militar:
deIndoleMilitar(aviacionMilitar).
deIndoleMilitar(inteligenciaMilitar).

% Modelamos los gustos de las personas:
leGusta('912ec803b2ce49e4a541068d495ab570',fuego).
leGusta('912ec803b2ce49e4a541068d495ab570',destruccion).
leGusta('f55840c38474c1909ce742172a77a013',ajedrez).
leGusta('f55840c38474c1909ce742172a77a013',juegosDeAzar).
leGusta('f55840c38474c1909ce742172a77a013',tiroAlBlanco).
leGusta('42fc1cd45335ad42d603657e5d0f2682',irALaPlaza).
leGusta('42fc1cd45335ad42d603657e5d0f2682',pelisDeGuerras).
leGusta('2e247e2eb505c42b362e80ed4d05b078',tiroAlBlanco).
leGusta('2e247e2eb505c42b362e80ed4d05b078',armandoBombas).

% Modelamos en que cosas son talentosas las personas:
tieneTalentoEn('912ec803b2ce49e4a541068d495ab570',armandoBombas).
tieneTalentoEn('2e416649e6ca0a1cbf9a1210cf4ce234',conduciendoAutos).
tieneTalentoEn('f55840c38474c1909ce742172a77a013',tiroAlBlanco).
tieneTalentoEn('42fc1cd45335ad42d603657e5d0f2682',tocarElPiano).
tieneTalentoEn('2e247e2eb505c42b362e80ed4d05b078',tiroAlBlanco).

% Agregamos los talentos considerados como terroristas:
esTerrorista(armandoBombas).
esTerrorista(tiroAlBlanco).

% Modelamos donde viven las personas:
viveEn('912ec803b2ce49e4a541068d495ab570',laSeverino).
viveEn('f55840c38474c1909ce742172a77a013',comisaria48).
viveEn('42fc1cd45335ad42d603657e5d0f2682',casaTenebrosa).
viveEn('2e247e2eb505c42b362e80ed4d05b078',rodrisHouse).
viveEn('2e247e2eb505c42b362e80ed4d05b078',laSeverino).

% Modelamos las viviendas:
    % formato de la vivienda vivienda(nombre,ancho,largo,tuneles).
vivienda(laSeverino,4,8,3).
vivienda(comisaria48,50,50,3).
vivienda(casaTenebrosa,10,10,20).
vivienda(rodrisHouse,10,20,0).
% Se agrega la vivienda sin habitantes para ver si cuando hacemos la consulta en la consola "viviendaSinHabitantes(Vivienda)", saliera esta vivienda:
vivienda(sinHabitantes,10,20,0).

% 2) Implemetar las reglas que permitan:
    % a) Poder saber quiénes son posibles disidentes.Una persona se considera posible disidente si cumple todos estos requisitos:
        % i) Tener una habilidad en algo considerado terrorista sin tener un trabajo de índole militar.
        % ii) No tener gustos registrados en sistema, o que le guste aquello en lo que es bueno.

    posiblesDisidentes(Persona):-
        persona(Persona),
        tieneHabilidadSospechosa(Persona),
        not(trabajaEnAlgoConIndoleMilitar(Persona)),    
        gustosSospechosos(Persona).

    tieneHabilidadSospechosa(Persona):-
        tieneTalentoEn(Persona,Talento),
        esTerrorista(Talento).

    trabajaEnAlgoConIndoleMilitar(Persona):-
        trabajaDe(Persona,AreaDeTrabajo),
        deIndoleMilitar(AreaDeTrabajo).

    % Aca hago un OR en caso de que la persona no le guste nada o le gusta algo en el que es talentoso
    gustosSospechosos(Persona):-
        not(leGusta(Persona,_)).

    gustosSospechosos(Persona):-
        leGusta(Persona,Algo),
        tieneTalentoEn(Persona,Algo).

    % 2) b) Detectar si en una vivienda: 
        % i) No vive nadie 
            viviendaSinHabitantes(Vivienda):-
                vivienda(Vivienda,_,_,_),
                not(viveEn(_,Vivienda)).
        % ii) Todos los que viven tienen al menos un gusto en común.
            habitantesTienenUnGustoEnComun(Vivienda):-
                vivienda(Vivienda,_,_,_),
                leGusta(_,Gusto),
                forall(viveEn(Habitante,Vivienda),leGusta(Habitante,Gusto)).
                % VERR

        %  iii) Encontrar todas las viviendas que tengan potencial rebelde. 
            % se consideran viviendas con potencial rebelde si vive en ella algún posible disidente y su superficie supera 50 metros cuadrados, lo que se calcula sumando su salón más 10 m por cada tunel. 

            viviendaPotencialRebelde(Vivienda):-
                posiblesDisidentes(Persona),
                viveEn(Persona,Vivienda),
                vivienda(Vivienda,Ancho,Largo,Tuneles),
                50 < Ancho*Largo + 10*Tuneles.
                % El salon es el ancho por el largo

        % 3) Mostrar ejemplos de consulta y respuesta.
            % 1) consultamos a la base de conocimiento por los posibles disidentes:
                % En la consola si ponemos: posiblesDisidentes(Persona).
                % Devuelve que el posible disidente es la persona con nombre: '2e247e2eb505c42b362e80ed4d05b078' (soy yo esa persona).
            
            % 2) consultamos a la base de conocimiento por las viviendas sin habitantes:
                % En la consola si ponemos: viviendaSinHabitantes(Vivienda)
                % Devuelve que la vivienda sin habitantes es: sinHabitantes (una vivienda creada a proposito)

            % 3) consultamos a la base de conocimiento por las viviendas con potencial rebelde:
                 % En la consola si ponemos: viviendaPotencialRebelde(Vivienda)
                 % Devuelve que la vivienda con potencial rebelde seria: comisaria48 

        % 4) Analizar la inversibilidad de los predicados, de manera de encontrar alguno de los realizados que sea totalmente inversible y otro que no. Justificar. 

            % Ejemplo de un predicado NO inversible es el de `posiblesDisidentes` del punto 2a)
            % Porque lo primero que hay que hacer es pedirle a la base de conocimientos todas las personas registradas en ella para hacer un correcto analisis de las personas posibles disidentes
            % Si se cambiara la condicion `persona(Persona)`, del primer lugar a ultimo, todavia sí se podria pedir personas a la base de conocimientos con la condicion siguiente `tieneHabilidadSospechosa(Persona)`,pero solo trae algunas de ellas, y el analisis no seria completo.

            % Otro ejemplo de predicado NO inversible es el de `viviendaSinHabitantes(Vivienda)` porque necesita primero que se validen todas las viviendas y a partir de alli,ver si existen algunas de ellas donde no haya habitantes. 

            % En este caso como criterio inversible lo veo a `gustosSospechosos(Persona)` del punto 2).Porque entiendo que para que esto sea posible,en un criterio,el orden de las condiciones al moverlas de lugar,deberian hacer que el criterio devuelva siempre lo mismo cuando se la consulta por algo. 
            % Y en este criterio veo que para ambos casos de `gustosSospechosos(Persona)`, si se le cambia el orden a sus condiciones siguen arrojando el mismo resultado.Por ejemplo si en un 1er caso tengo el criterio
            % `gustosSospechosos(Persona)` definido asi:

                % gustosSospechosos(Persona):-
                %     not(leGusta(Persona,_)).
            
                % gustosSospechosos(Persona):-
                %     leGusta(Persona,Algo),
                %     tieneTalentoEn(Persona,Algo).
            
            % Y luego los tengo definidos asi:
                % gustosSospechosos(Persona):-
                %     not(leGusta(Persona,_)).
            
                % gustosSospechosos(Persona):-
                %     tieneTalentoEn(Persona,Algo),
                %     leGusta(Persona,Algo).

            % Arrojan el mismo resultado cuando se les consulta.Devuelve a las persoans:
                % Persona = f55840c38474c1909ce742172a77a013 ;
                % Persona = '2e247e2eb505c42b362e80ed4d05b078' ;
