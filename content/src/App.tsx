import React, { useState } from 'react';
import logo from './logo.svg';
import './App.css';
import HelloWorldView from './views/HelloWorldView';
import { Route, Routes } from 'react-router-dom';
import DefaultLayout from './layout/DefaultLayout';
import HomeView from './views/HomeView';
import PixiView from './views/PixiView';

function App() {
  return (
    <Routes>
      <Route path='/' element={<DefaultLayout/>}>
        <Route index element={<HomeView/>} />
        <Route path='hello' element={<HelloWorldView/>} />
      </Route>
      <Route path='/pixi' element={<PixiView/>} />
    </Routes>
  );
}

export default App;
