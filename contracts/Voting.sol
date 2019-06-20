pragma solidity ^0.5.8;

contract Voting {

    // Evento que se lanza si se añade un candidato
    event AddedCandidate(uint candidateID);

    // registramos la dirección del dueño del contrato en una variable address
    address owner;
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require (msg.sender == owner, "Solo el propietario del contrato puede acceder a esta función");
        _;
    }

    // Estructura para almacenar información asociada al Votante
    struct Voter {
        bytes32 uid; // id votante (dirección)
        uint candidateIDVote; // candidato al que vota el votante
    }
    // Estructura para almacenar información asociada al Candidato
    struct Candidate {
        bytes32 name;   // nombre del condidato
        bytes32 party;  // partido del candidato
        bool doesExist; // booleano para chequear si el candidato existe
    }

    uint numCandidates; // variable que almacena el número de candidatos
    uint numVoters; // variable que almacena el número de votantes

    // Mapping clave (uint) -  valor (estrucutra Candidate/Voter)
    mapping (uint => Candidate) candidates;
    mapping (uint => Voter) voters;

    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     * * * * * * * * * * * * * * FUNCIONES * * * * * * * * * * * * *
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

    // Función que me permite añadir a un cadidato.
    // Solo el propietario del contrato podrá añadir al candidato
    function addCandidate(bytes32 name, bytes32 party) public onlyOwner
    {
        // ID del candidato: Número de candidato añadido al mapping (clave)
        uint candidateID = numCandidates++;
        // Creamos un nuevo candidato: Nombre, Partido y existe
        candidates[candidateID] = Candidate(name,party,true);
        // Emitimos el evento
        emit AddedCandidate(candidateID);
    }

    // Función que me permite a un votante votar por un candidato
    function vote(bytes32 uid, uint candidateID) public {
        // Verificamos si el candidato al que voy a votar existe
        if (candidates[candidateID].doesExist == true)
        {
            // ID del votante: Número de votante añadido al mapping (clave)
            uint voterID = numVoters++; //voterID is the return variable
            // Creamos un nuevo votante: Dirección, candidatoID
            voters[voterID] = Voter(uid,candidateID);
        }
    }

    // Función que deveulve el número de votos de un candidato específico
    function totalVotes(uint candidateID) public view  returns (uint) {
        uint numOfVotes = 0;
        // De todos los votos, contamos solo los del candidato candidateID
        for (uint i = 0; i < numVoters; i++) {
            if (voters[i].candidateIDVote == candidateID) {
                numOfVotes++;
            }
        }
        return numOfVotes;
    }

    // Función que devuelve el núemero de candidatos
    function getNumOfCandidates() public view returns(uint) {
        return numCandidates;
    }

    // Función que devuelve el núemero de votantes
    function getNumOfVoters() public view returns(uint) {
        return numVoters;
    }

    // Función que devuelve la información de un candidato concreto
    function getCandidate(uint candidateID) public view returns (uint,bytes32, bytes32) {
        return (candidateID,candidates[candidateID].name,candidates[candidateID].party);
    }
}