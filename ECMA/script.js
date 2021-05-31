var startwidth       = window.innerWidth;
var startheight      = window.innerHeight;
var width            = startwidth;
var height           = startheight;
var wait             = false;

function getWindowWidth()
{

    if ( wait       == false )
    {
        wait         = true;

        width        = window.innerWidth;
        height       = window.innerHeight;

        side         = width * 0.15;
        main         = width * 0.85;
        pixel        = width / 1920;

        root         = document.querySelector( ':root' );

                       root.style.setProperty( '--root'     , width + "px" );
                       root.style.setProperty( '--side'     ,  side + "px" );
                       root.style.setProperty( '--main'     ,  main + "px" );
                       root.style.setProperty( '--pixel'    , pixel + "px" );

        $top         = document.querySelector( '#top'  );
        $side        = document.querySelector( '#side' );
        $body        = document.querySelector( 'body'  );
        $main        = document.querySelector( '#main' );
        
        if ( width   <  720 )
        {
            $side.style.setProperty( 'display'        ,       'none' );
             $top.style.setProperty( 'display'        ,       'flex' );
            $body.style.setProperty( 'flex-direction' ,     'column' );
             root.style.setProperty( '--content'      , width + 'px' );
        }

        if ( width   >= 720 )
        {
            $side.style.setProperty( 'display'        ,       'flex' );
             $top.style.setProperty( 'display'        ,       'none' );
            $body.style.setProperty( 'flex-direction' ,        'row' );
             root.style.setProperty( '--content'      ,  main + 'px' );
        }
    }

    setTimeout( () =>
    {
        wait = false;
        
    }, 200 );
}
    
getWindowWidth();
    
window.addEventListener( 'resize' , getWindowWidth );
window.addEventListener("deviceorientation", getWindowWidth , true);
