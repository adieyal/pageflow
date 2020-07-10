import React, {createContext, useContext, useEffect, useRef, useMemo} from 'react';
import {media, MultiPlayer, PlayerSourceIDMap} from 'pageflow/frontend';
import {Atmo} from './Atmo';

function getContextValue(updateAtmo, createMediaPlayerHooks){
  let empty = ()=>{};
  return {
    updateAtmo: updateAtmo || empty,
    createMediaPlayerHooks: createMediaPlayerHooks || empty
  }
}

const AtmoContext = createContext(getContextValue());

export function AtmoProvider({children}){
  let atmoConfig = useRef({});

  useEffect(()=>{
    let currentAtmo = atmoConfig.current;
    currentAtmo.pool = PlayerSourceIDMap(media, {
      playerOptions: {tagName: 'audio'}
    });
    currentAtmo.multiPlayer = new MultiPlayer(currentAtmo.pool, {
      loop: true,
      fadeDuration: 500,
      crossFade: true,
      playFromBeginning: false,
      rewindOnChange: true,
      pauseInBackground: true
    });
    currentAtmo.atmo = new Atmo({
      multiPlayer: currentAtmo.multiPlayer,
      backgroundMedia: media
    });
  }, []);

  let updateAtmo = function (config) {
    let currentAtmo = atmoConfig.current;
    if (currentAtmo.atmo) {
      if (config.sources) {
        currentAtmo.pool.mapSources(config.atmoAudioFileId, config.sources);
      }
      
      currentAtmo.atmo.atmoSourceId = config.atmoAudioFileId;
      currentAtmo.atmo.update();
    }
  };

  let createMediaPlayerHooks = function (options) {
    return atmoConfig.current.atmo.createMediaPlayerHooks(options);
  }

  let contextValue = useMemo(()=>{
    return getContextValue(updateAtmo, createMediaPlayerHooks);
  }, []);

  return (
    <AtmoContext.Provider value={contextValue}>
      {children}
    </AtmoContext.Provider>
  )
};

export function useAtmo() {
  return useContext(AtmoContext);
}
