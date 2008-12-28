// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function dropout(element)
{
     new Effect.Parallel(
       [ new Effect.Highlight(element), 
         new Effect.MoveBy(element, 500, 0, { sync: true }), 
         new Effect.Opacity(element, { sync: true, to: 0.0, from: 1.0 } ) ], 
       { duration: 1, 
        afterFinish: function(effect)
          { Element.hide(effect.effects[0].element); } 
       });
}