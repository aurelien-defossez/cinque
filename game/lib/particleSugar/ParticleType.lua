---
-- Created by IntelliJ IDEA.
-- @author callin2@gmail.com
-- @copyright 2012 임창진
--

require 'lib.Coat.Coat'

---------------------------------------------------------------------------------------------
class 'lib.particleSugar.ParticleType'

has.name        = {is="rw", isa="string"}
has.prop        = {is="rw", isa="table", default=function() return {} end}

function method:DEMOLISH()
    self.name =  nil
    self.prop = nil
end
