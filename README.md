## Astra

__Astra__ is simple library for [Starling](https://github.com/Gamua/Starling-Framework). It offers:

    Views/Mediators mapping
    Events/Commands mapping
    Tasks & Services managment
    
### Creating a Context

Create a __Contex__ after Starlig root created:
```js

    starling.addEventListener(Event.ROOT_CREATED, starling_ROOT_CREATED);

```
like this:
```js
protected function starling_ROOT_CREATED(evt:Event):void
{
    var context:IStarlingDispalyContext = new AppContext();
    context.contextView =  Starling.current.root as DisplayObjectContainer;
}
```
after that will be call `initialize()` method inside `RootMediator` (it will be main enter point) that was configure in `AppContext`, for example:
```js
import ...

public class AppContext extends StarlingContext
{
    
    public function AppContext()
    {
        super();
    }
    override protected function initialize():void
    {
        mapMediator(Root, RootMediator);
        mapMediator(Game, GameMediator);
        
        mapCommand(GameEvent.INIT_GAME_PRLG, GameEvent, InitGameCmd);
        mapCommand(GameEvent.HUMAN_MOVED_TO, GameEvent, GetNextStupidMoveCmd);
    }
}
}
```
### Manage Views/Mediators

Some Views can be mapped to its Mediators inside application Context, like show above:

```js
mapMediator(Root, RootMediator);
```

Typical Mediator:
```js
public class RootMediator extends Mediator
{
    private var _vRoot:Root;
    public function RootMediator()
    {
        super();
    }
    override public function initialize():void
    {
        _vRoot = view as Root;
        addContextListener( AppEvent.START_GAME, context_START_GAME);
    }
    private function context_START_GAME(evt:AppEvent):void
    {
        // ...
    }
    override public function dispose():void
    {
        removeContextListener( AppEvent.START_GAME, context_START_GAME);
    }
}
```
> __Note:__ All Mediators has to inherited from library class `Mediator`

Overridden methods `initialize()` and `dispose()` being of phases of Life Cycle. In initialize phase you must add context listeners, manage view and its children etc. In dispose phase you must clean links on objects, delete data and remove listeners.

> __Note:__ All Views has to inherited from library class `ContextView`, for example:
```js
public class Root extends ContextView
```
### Manage Events/Commands

Some Events can be mapped to its Commands inside application Context, like show above:
```js
mapCommand(GameEvent.INIT_GAME_PRLG, GameEvent, InitGameCmd);
```

>*TODO: Add description about of Tasks and Services managing*

Dependencies:

- [AIR SDK](https://www.adobe.com/devnet/air/air-sdk-download.html)
- [Starling 2.5.1](https://github.com/Gamua/Starling-Framework/releases/download/v2.5.1/starling-2.5.1.zip)

other:

> Just add `libs/ascommons-logging-2.7.swc` in project dependencies.
