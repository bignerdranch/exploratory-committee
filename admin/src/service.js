import axios from 'axios';

export default {
  getAllProjects() {
    console.log('HALLLLO');
    return axios.get('http://localhost:3000/')
      .then(res => res.data).catch(err => console.log('cant get all projects', err))
  },

  getProject(id) {
    return axios.get('http://localhost:3000/project', { params: { id }})
      .then(res => res.data[0]).catch(err => console.log('cant get all projects', err))
  },

  addNewProject(name) {
    return axios.post('http://localhost:3000/', { name })
      .then(res => res).catch(err => console.log('could not add new project', err))
  },
  
  updateSceen(id, screens) {
    return axios.put('http://localhost:3000/project', { id, screens })
      .then(res => res).catch(err => console.log('could not add new project', err))
  },
};