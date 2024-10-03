import React,{useState,useEffect} from 'react';
import './App.css';

function App() {
  const [data,setData]=useState([]);
  
  const getData=()=>{
    fetch('https://us-central1-resolute-ascent-429512-h0.cloudfunctions.net/get_movies'
    ,{
      headers : { 
        'Content-Type': 'application/json',
        'Accept': 'application/json'
       }
    }
    )
      .then(function(response){
        console.log(response)
        return response.json();
      })
      .then(function(myJson) {
        console.log(myJson);
        setData(myJson)
      });
  }
  useEffect(()=>{
    getData()
  },[])
  return (
    <div className="App">
      <h1>Favorite movies</h1>
     {
       data && data.length > 0 && data.map((item, index) => (
        <div key={index}>
          <p>Movie name: {item.title}</p>
          <p>Director: {item.director}</p>
          <p>Rating: {item.rating}</p>
          <img src={item.image_url} width={200} height={300}/>
          
        
        </div>
      
      ))
     }
    </div>
  );
}

export default App;