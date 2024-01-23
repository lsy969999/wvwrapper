import React, { createRef, useEffect } from 'react'
import * as PIXI from 'pixi.js'


const CanvasGameView = () => {
  // let pixiApp: PIXI.Application
  const canvasRef = createRef<HTMLDivElement>()
  useEffect(()=>{
    const pixiApp = new PIXI.Application<HTMLCanvasElement>({
      backgroundColor: 0x3495ed,
      width: window.innerWidth ,
      height: window.innerHeight ,
    })
    canvasRef.current?.appendChild(pixiApp.view)

    const clampy = PIXI.Sprite.from('/images/klipartz.com.png')
    clampy.anchor.set(0.5)
    clampy.x = pixiApp.screen.width / 2
    clampy.y = pixiApp.screen.height / 2
    clampy.width = 50
    clampy.height = 50
    
    pixiApp.stage.addChild(clampy)

    pixiApp.ticker.add((delta) =>
    {
        // just for fun, let's rotate mr rabbit a little
        // delta is 1 if running at 100% performance
        // creates frame-independent transformation
        clampy.rotation += 0.1 * delta;
    });

    return ()=>{
      pixiApp.stop()
      pixiApp.destroy(true)
    }
  })
  return (
    <div ref={canvasRef}></div>
  )
}

export default CanvasGameView